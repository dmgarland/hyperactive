import de.alex_uhlmann.animationpackage.utility.IVisitor;
interface de.alex_uhlmann.animationpackage.utility.IVisitorElement {
	public function accept(visitor:IVisitor):Void;
}