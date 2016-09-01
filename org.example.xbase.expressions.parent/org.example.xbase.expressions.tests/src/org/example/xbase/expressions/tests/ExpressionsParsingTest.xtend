/*
 * generated by Xtext 2.10.0
 */
package org.example.xbase.expressions.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.example.xbase.expressions.expressions.ExpressionsModel
import static extension org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import org.example.xbase.expressions.expressions.EvalExpression
import org.eclipse.xtext.xbase.XMemberFeatureCall

@RunWith(XtextRunner)
@InjectWith(ExpressionsInjectorProvider)
class ExpressionsParsingTest {

	@Inject extension ParseHelper<ExpressionsModel>

	@Test
	def void loadModel() {
		val result = parse('''
			println("Hello Xtext!")
		''')
		assertNotNull(result)
	}

	@Test
	def void testEvalExpression() {
		'''
			val i = 0
			eval i
		'''.parse.expressions.last => [
			assertTrue(it instanceof EvalExpression)
		]
	}

	@Test
	def void testEvalExpressionAsReceiver() {
		'''
			val i = 0
			(eval i).toString
		'''.parse.expressions.last => [
			assertTrue("type " + class, (it as XMemberFeatureCall).actualReceiver instanceof EvalExpression)
		]
	}

	@Test
	def void testEvalExpressionAssociativity() {
		'''
			val i = 0
			eval i.toString
		'''.parse.expressions.last => [
			assertTrue("type " + class, (it as EvalExpression).expression instanceof XMemberFeatureCall)
		]
	}
}