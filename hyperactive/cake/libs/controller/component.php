<?php
/* SVN FILE: $Id: component.php 5317 2007-06-20 08:28:35Z phpnut $ */
/**
 *
 * PHP versions 4 and 5
 *
 * CakePHP(tm) :  Rapid Development Framework <http://www.cakephp.org/>
 * Copyright 2005-2007, Cake Software Foundation, Inc.
 *								1785 E. Sahara Avenue, Suite 490-204
 *								Las Vegas, Nevada 89104
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2005-2007, Cake Software Foundation, Inc.
 * @link				http://www.cakefoundation.org/projects/info/cakephp CakePHP(tm) Project
 * @package			cake
 * @subpackage		cake.cake.libs.controller
 * @since			CakePHP(tm) v TBD
 * @version			$Revision: 5317 $
 * @modifiedby		$LastChangedBy: phpnut $
 * @lastmodified	$Date: 2007-06-20 03:28:35 -0500 (Wed, 20 Jun 2007) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
/**
 * Component
 *
 * Used to create instances of applications components
 *
 * @package		cake
 * @subpackage	cake.cake.libs.controller
 */
class Component extends Object {
/**
 * Instance Controller
 *
 * @var object
 * @access private
 */
	var $__controller = null;
/**
 * Constructor
 */
	function __construct() {
	}
/**
 * Used to initialize the components for current controller
 *
 * @param object $controller
 * @access public
 */
	function init(&$controller) {
		$this->__controller =& $controller;

		if ($this->__controller->components !== false) {
			$loaded = array();
			$this->__controller->components = array_merge($this->__controller->components, array('Session'));
			$loaded = $this->__loadComponents($loaded, $this->__controller->components);

			foreach (array_keys($loaded)as $component) {
				$tempComponent =& $loaded[$component];

				if (isset($tempComponent->components) && is_array($tempComponent->components)) {
					foreach ($tempComponent->components as $subComponent) {
						$this->__controller->{$component}->{$subComponent} =& $loaded[$subComponent];
					}
				}
			}
		}
	}

/**
 * Enter description here...
 *
 * @param array $loaded
 * @param array $components
 * @return loaded components
 * @access private
 */
	function &__loadComponents(&$loaded, $components) {
		foreach ($components as $component) {
			$parts = preg_split('/\/|\./', $component);

			if (count($parts) === 1) {
				$plugin = $this->__controller->plugin;
			} else {
				$plugin = Inflector::underscore($parts['0']);
				$component = $parts[count($parts) - 1];
			}

			$componentCn = $component . 'Component';

			if (in_array($component, array_keys($loaded)) !== true) {

				if (!class_exists($componentCn)) {

					if (is_null($plugin) || !loadPluginComponent($plugin, $component)) {

						if (!loadComponent($component)) {
							$this->cakeError('missingComponentFile', array(array(
													'className' => $this->__controller->name,
													'component' => $component,
													'file' => Inflector::underscore($component) . '.php',
													'base' => $this->__controller->base)));
							exit();
						}
					}

					if (!class_exists($componentCn)) {
						$this->cakeError('missingComponentClass', array(array(
												'className' => $this->__controller->name,
												'component' => $component,
												'file' => Inflector::underscore($component) . '.php',
												'base' => $this->__controller->base)));
						exit();
					}
				}

				if ($componentCn == 'SessionComponent') {
					$param = strip_plugin($this->__controller->base, $this->__controller->plugin) . '/';
				} else {
					$param = null;
				}
				$this->__controller->{$component} =& new $componentCn($param);
				$loaded[$component] =& $this->__controller->{$component};

				if (isset($this->__controller->{$component}->components) && is_array($this->__controller->{$component}->components)) {
					$loaded =& $this->__loadComponents($loaded, $this->__controller->{$component}->components);
				}
			}
		}
		return $loaded;
	}
}
?>