package org.example.xbase.expressions.ui.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(ExpressionsUiInjectorProvider)
class XbaseExpressionsContentAssistTest extends AbstractContentAssistTest {

	@Test
	def void testEmptyProgram() {
		newBuilder.assertProposal("val")
	}

	@Test
	def void testEvalArgument() {
		newBuilder.append("val myVar = 0; eval ").assertProposal("myVar")
	}

}