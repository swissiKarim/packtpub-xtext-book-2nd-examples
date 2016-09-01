/*
 * generated by Xtext 2.10.0
 */
package org.example.expressions.validation

import com.google.inject.Inject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.Check
import org.example.expressions.ExpressionsModelUtil
import org.example.expressions.expressions.And
import org.example.expressions.expressions.Comparison
import org.example.expressions.expressions.Equality
import org.example.expressions.expressions.Expression
import org.example.expressions.expressions.ExpressionsPackage
import org.example.expressions.expressions.Minus
import org.example.expressions.expressions.MulOrDiv
import org.example.expressions.expressions.Not
import org.example.expressions.expressions.Or
import org.example.expressions.expressions.Plus
import org.example.expressions.expressions.VariableRef
import org.example.expressions.typing.ExpressionsType
import org.example.expressions.typing.ExpressionsTypeComputer

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class ExpressionsValidator extends AbstractExpressionsValidator {

	protected static val ISSUE_CODE_PREFIX = "org.example.expressions."
	public static val FORWARD_REFERENCE = ISSUE_CODE_PREFIX + "ForwardReference"
	public static val TYPE_MISMATCH = ISSUE_CODE_PREFIX + "TypeMismatch"

	@Inject extension ExpressionsModelUtil
	@Inject extension ExpressionsTypeComputer

	@Check
	def void checkForwardReference(VariableRef varRef) {
		val variable = varRef.getVariable()
		if (!varRef.isVariableDefinedBefore)
			error("variable forward reference not allowed: '" + variable.name + "'",
				ExpressionsPackage.eINSTANCE.variableRef_Variable,
				FORWARD_REFERENCE,
				variable.name)
	}

	@Check def checkType(Not not) {
		checkExpectedBoolean(not.expression,
			ExpressionsPackage.Literals.NOT__EXPRESSION)
	}

	@Check def checkType(And and) {
		checkExpectedBoolean(and.left, ExpressionsPackage.Literals.AND__LEFT)
		checkExpectedBoolean(and.right, ExpressionsPackage.Literals.AND__RIGHT)
	}

	@Check
	def checkType(Or or) {
		checkExpectedBoolean(or.left, ExpressionsPackage.Literals.OR__LEFT)
		checkExpectedBoolean(or.right, ExpressionsPackage.Literals.OR__RIGHT)
	}

	@Check
	def checkType(MulOrDiv mulOrDiv) {
		checkExpectedInt(mulOrDiv.left, ExpressionsPackage.Literals.MUL_OR_DIV__LEFT)
		checkExpectedInt(mulOrDiv.right, ExpressionsPackage.Literals.MUL_OR_DIV__RIGHT)
	}

	@Check
	def checkType(Minus minus) {
		checkExpectedInt(minus.left, ExpressionsPackage.Literals.MINUS__LEFT)
		checkExpectedInt(minus.right, ExpressionsPackage.Literals.MINUS__RIGHT)
	}

	@Check def checkType(Equality equality) {
		val leftType = getTypeAndCheckNotNull(equality.left, ExpressionsPackage.Literals.EQUALITY__LEFT)
		val rightType = getTypeAndCheckNotNull(equality.right, ExpressionsPackage.Literals.EQUALITY__RIGHT)
		checkExpectedSame(leftType, rightType)
	}

	@Check def checkType(Comparison comparison) {
		val leftType = getTypeAndCheckNotNull(comparison.left, ExpressionsPackage.Literals.COMPARISON__LEFT)
		val rightType = getTypeAndCheckNotNull(comparison.right, ExpressionsPackage.Literals.COMPARISON__RIGHT)
		checkExpectedSame(leftType, rightType)
		checkNotBoolean(leftType, ExpressionsPackage.Literals.COMPARISON__LEFT)
		checkNotBoolean(rightType, ExpressionsPackage.Literals.COMPARISON__RIGHT)
	}

	@Check def checkType(Plus plus) {
		val leftType = getTypeAndCheckNotNull(plus.left, ExpressionsPackage.Literals.PLUS__LEFT)
		val rightType = getTypeAndCheckNotNull(plus.right, ExpressionsPackage.Literals.PLUS__RIGHT)
		if (leftType.isIntType || rightType.isIntType ||
			(!leftType.isStringType && !rightType.isStringType)) {
			checkNotBoolean(leftType, ExpressionsPackage.Literals.PLUS__LEFT)
			checkNotBoolean(rightType, ExpressionsPackage.Literals.PLUS__RIGHT)
		}
	}

	def private checkExpectedSame(ExpressionsType left, ExpressionsType right) {
		if (right != null && left != null && right != left) {
			error("expected the same type, but was " + left + ", " + right,
				ExpressionsPackage.Literals.EQUALITY.getEIDAttribute(), TYPE_MISMATCH)
		}
	}

	def private checkNotBoolean(ExpressionsType type, EReference reference) {
		if (type.isBoolType) {
			error("cannot be boolean", reference, TYPE_MISMATCH)
		}
	}

	def private checkExpectedBoolean(Expression exp, EReference reference) {
		checkExpectedType(exp, ExpressionsTypeComputer.BOOL_TYPE, reference)
	}

	def private checkExpectedInt(Expression exp, EReference reference) {
		checkExpectedType(exp, ExpressionsTypeComputer.INT_TYPE, reference)
	}

	def private checkExpectedType(Expression exp, ExpressionsType expectedType, EReference reference) {
		val actualType = getTypeAndCheckNotNull(exp, reference)
		if (actualType != expectedType)
			error("expected " + expectedType + " type, but was " + actualType,
				reference, TYPE_MISMATCH
			)
	}

	def private ExpressionsType getTypeAndCheckNotNull(Expression exp, EReference reference) {
		val type = exp?.typeFor
		if (type == null)
			error("null type", reference, TYPE_MISMATCH)
		return type;
	}
}