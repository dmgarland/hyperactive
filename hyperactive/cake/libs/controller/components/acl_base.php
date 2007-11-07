<?php
/* SVN FILE: $Id: acl_base.php 5144 2007-05-21 04:46:30Z phpnut $ */
/**
 * Access Control List abstract class.
 *
 * Long description for file
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
 * @subpackage		cake.cake.libs.controller.components
 * @since			CakePHP(tm) v 0.10.0.1232
 * @version			$Revision: 5144 $
 * @modifiedby		$LastChangedBy: phpnut $
 * @lastmodified	$Date: 2007-05-20 23:46:30 -0500 (Sun, 20 May 2007) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
/**
 * Access Control List abstract class. Not to be instantiated.
 * Subclasses of this class are used by AclComponent to perform ACL checks in Cake.
 *
 * @package 	cake
 * @subpackage	cake.cake.libs.controller.components
 * @abstract
 */
class AclBase extends Object {
/**
 * This class should never be instantiated, just subclassed.
 *
 * No instantiations or constructor calls (even statically)
 *
 * @return AclBase
 * @abstract
 */
	function __construct() {
		if (strcasecmp(get_class($this), "AclBase") == 0 || !is_subclass_of($this, "AclBase")) {
			trigger_error("[acl_base] The AclBase class constructor has been called, or the class was instantiated. This class must remain abstract. Please refer to the Cake docs for ACL configuration.", E_USER_ERROR);
			return null;
		}
	}
/**
 * Empty method to be overridden in subclasses
 *
 * @param string $aro
 * @param string $aco
 * @param string $action
 * @abstract
 */
	function check($aro, $aco, $action = "*") {
	}
}
?>