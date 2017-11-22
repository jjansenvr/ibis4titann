package nl.nn.ibistesttool.transform;

import java.util.Properties;

import nl.nn.adapterframework.util.LogUtil;
import nl.nn.adapterframework.util.Misc;
import nl.nn.adapterframework.util.XmlUtils;
import nl.nn.testtool.transform.MessageTransformer;

import org.apache.commons.lang.StringUtils;

/**
 * Hide the same data as is hidden in the Ibis logfiles based on the
 * log.hideRegex property in log4j4ibis.properties.
 * 
 * @author Jaco de Groot
 */
public class HideRegexMessageTransformer implements MessageTransformer {
	String hideRegex;
	String replaceRegex;

	HideRegexMessageTransformer() {
		
		Properties log4jProperties = LogUtil.getLog4jProperties();
		hideRegex = log4jProperties.getProperty("log.hideRegex");
		replaceRegex = log4jProperties.getProperty("log.replaceRegex");
		
		if (hideRegex != null) {
			hideRegex = XmlUtils.decodeChars(hideRegex);
		}
		if (replaceRegex != null) {
			replaceRegex = XmlUtils.decodeChars(replaceRegex);
		}
		
	}

	public String transform(String message) {
		if (StringUtils.isNotEmpty(hideRegex) && message != null) {
			message = message.replaceAll(hideRegex,"**********");
		}
		if (StringUtils.isNotEmpty(replaceRegex) && message != null) {
			message = message.replaceAll(replaceRegex, "$1*removed*$2");
		}
		return message;
	}

	public String getHideRegex() {
		return hideRegex;
	}

	public void setHideRegex(String string) {
		hideRegex = string;
	}
	public String getReplaceRegex() {
		return replaceRegex;
	}

	public void setReplaceRegex(String string) {
		replaceRegex = string;
	}

}
