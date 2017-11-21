/*
   Copyright 2013, 2016 Nationale-Nederlanden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
package nl.nn.adapterframework.pipes;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;

import nl.nn.adapterframework.configuration.ConfigurationException;
import nl.nn.adapterframework.core.IDataIterator;
import nl.nn.adapterframework.core.IPipeLineSession;
import nl.nn.adapterframework.core.ISender;
import nl.nn.adapterframework.core.ISenderWithParameters;
import nl.nn.adapterframework.core.SenderException;
import nl.nn.adapterframework.core.TimeOutException;
import nl.nn.adapterframework.parameters.ParameterResolutionContext;
import nl.nn.adapterframework.senders.SenderExecutor;
import nl.nn.adapterframework.statistics.StatisticsKeeper;
import nl.nn.adapterframework.statistics.StatisticsKeeperIterationHandler;
import nl.nn.adapterframework.util.ClassUtils;
import nl.nn.adapterframework.util.DomBuilderException;
import nl.nn.adapterframework.util.Guard;
import nl.nn.adapterframework.util.TransformerPool;
import nl.nn.adapterframework.util.XmlUtils;

import org.apache.commons.lang.StringUtils;
import org.springframework.core.task.TaskExecutor;

/**
 * Abstract base class to sends a message to a Sender for each item returned by a configurable iterator.
 * 
 * <p><b>Configuration:</b>
 * <table border="1">
 * <tr><th>attributes</th><th>description</th><th>default</th></tr>
 * <tr><td>className</td><td>nl.nn.adapterframework.pipes.IteratingPipe</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setName(String) name}</td><td>name of the Pipe</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setParallel(boolean) parallel}</td><td> when set <code>true</code>, the calls for all items are done in parallel (a new thread is started for each call). When collectResults set <code>true</code> this pipe will wait for all calls to finish before results are collected and pipe result is returned</td><td>false</td></tr>
 * <tr><td>{@link #setDurationThreshold(long) durationThreshold}</td><td>if durationThreshold >=0 and the duration (in milliseconds) of the message processing exceeded the value specified the message is logged informatory</td><td>-1</td></tr>
 * <tr><td>{@link #setGetInputFromSessionKey(String) getInputFromSessionKey}</td><td>when set, input is taken from this session key, instead of regular input</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setStoreResultInSessionKey(String) storeResultInSessionKey}</td><td>when set, the result is stored under this session key</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setCheckXmlWellFormed(boolean) checkXmlWellFormed}</td><td>when set <code>true</code>, the XML well-formedness of the result is checked</td><td>false</td></tr>
 * <tr><td>{@link #setPreserveInput(boolean) preserveInput}</td><td>when set <code>true</code>, the input of a pipe is restored before processing the next one</td><td>false</td></tr>
 * <tr><td>{@link #setNamespaceAware(boolean) namespaceAware}</td><td>controls namespaceAwareness for parameters</td><td>application default</td></tr>
 * <tr><td>{@link #setTransactionAttribute(String) transactionAttribute}</td><td>Defines transaction and isolation behaviour. Equal to <A href="http://java.sun.com/j2ee/sdk_1.2.1/techdocs/guides/ejb/html/Transaction2.html#10494">EJB transaction attribute</a>. Possible values are: 
 *   <table border="1">
 *   <tr><th>transactionAttribute</th><th>callers Transaction</th><th>Pipe excecuted in Transaction</th></tr>
 *   <tr><td colspan="1" rowspan="2">Required</td>    <td>none</td><td>T2</td></tr>
 * 											      <tr><td>T1</td>  <td>T1</td></tr>
 *   <tr><td colspan="1" rowspan="2">RequiresNew</td> <td>none</td><td>T2</td></tr>
 * 											      <tr><td>T1</td>  <td>T2</td></tr>
 *   <tr><td colspan="1" rowspan="2">Mandatory</td>   <td>none</td><td>error</td></tr>
 * 											      <tr><td>T1</td>  <td>T1</td></tr>
 *   <tr><td colspan="1" rowspan="2">NotSupported</td><td>none</td><td>none</td></tr>
 * 											      <tr><td>T1</td>  <td>none</td></tr>
 *   <tr><td colspan="1" rowspan="2">Supports</td>    <td>none</td><td>none</td></tr>
 * 											      <tr><td>T1</td>  <td>T1</td></tr>
 *   <tr><td colspan="1" rowspan="2">Never</td>       <td>none</td><td>none</td></tr>
 * 											      <tr><td>T1</td>  <td>error</td></tr>
 *  </table></td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setForwardName(String) forwardName}</td>  <td>name of forward returned upon completion</td><td>"success"</td></tr>
 * <tr><td>{@link #setResultOnTimeOut(String) resultOnTimeOut}</td><td>result returned when no return-message was received within the timeout limit (e.g. "receiver timed out").</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setLinkMethod(String) linkMethod}</td><td>Indicates wether the server uses the correlationID or the messageID in the correlationID field of the reply</td><td>CORRELATIONID</td></tr>
 * <tr><td>{@link #setAuditTrailXPath(String) auditTrailXPath}</td><td>xpath expression to extract audit trail from message</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setCorrelationIDXPath(String) correlationIDXPath}</td><td>xpath expression to extract correlationID from message</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setStyleSheetName(String) styleSheetName}</td><td>stylesheet to apply to each message, before sending it</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setXpathExpression(String) xpathExpression}</td><td>alternatively: XPath-expression to create stylesheet from</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setNamespaceDefs(String) namespaceDefs}</td><td>namespace defintions for xpathExpression. Must be in the form of a comma or space separated list of <code>prefix=namespaceuri</code>-definitions</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setOutputType(String) outputType}</td><td>either 'text' or 'xml'. Only valid for xpathExpression</td><td>text</td></tr>
 * <tr><td>{@link #setOmitXmlDeclaration(boolean) omitXmlDeclaration}</td><td>force the transformer generated from the XPath-expression to omit the xml declaration</td><td>true</td></tr>
 * <tr><td>{@link #setIgnoreExceptions(boolean) ignoreExceptions}</td><td>when <code>true</code> ignore any exception thrown by executing sender</td><td>false</td></tr>
 * <tr><td>{@link #setStopConditionXPathExpression(String) stopConditionXPathExpression}</td><td>expression evaluated on each result if set. 
 * 		Iteration stops if condition returns anything other than <code>false</code> or an empty result.
 * For example, to stop after the second child element has been processed, one of the following expressions could be used:
 * <table> 
 * <tr><td><li><code>result[@item='2']</code></td><td>returns result element after second child element has been processed</td></tr>
 * <tr><td><li><code>result/@item='2'</code></td><td>returns <code>false</code> after second child element has been processed, <code>true</code> for others</td></tr>
 * </table> 
 * </td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setRemoveXmlDeclarationInResults(boolean) removeXmlDeclarationInResults}</td><td>postprocess each partial result, to remove the xml-declaration, as this is not allowed inside an xml-document</td><td>false</td></tr>
 * <tr><td>{@link #setCollectResults(boolean) collectResults}</td><td>controls whether all the results of each iteration will be collected in one result message. If set <code>false</code>, only a small summary is returned</td><td>true</td></tr>
 * <tr><td>{@link #setBlockSize(int) blockSize}</td><td>controls multiline behaviour. when set to a value greater than 0, it specifies the number of rows send in a block to the sender.</td><td>0 (one line at a time, no prefix of suffix)</td></tr>
 * <tr><td>{@link #setBlockPrefix(String) blockPrefix}</td><td>When <code>blockSize &gt; 0</code>, this string is inserted at the start of the set of lines.</td><td>&lt;block&gt;</td></tr>
 * <tr><td>{@link #setBlockSuffix(String) blockSuffix}</td><td>When <code>blockSize &gt; 0</code>, this string is inserted at the end of the set of lines.</td><td>&lt;/block&gt;</td></tr>
 * <tr><td>{@link #setStartPosition(int) startPosition}</td><td>When <code>startPosition &gt;= 0</code>, this field contains the start position of the key in the current record (first character is 0); all sequenced lines with the same key are put in one block and send to the sender</td><td>-1</td></tr>
 * <tr><td>{@link #setEndPosition(int) endPosition}</td><td>When <code>endPosition &gt;= startPosition</code>, this field contains the end position of the key in the current record</td><td>-1</td></tr>
 * <tr><td>{@link #setLinePrefix(String) linePrefix}</td><td>this string is inserted at the start of each line</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setLineSuffix(String) lineSuffix}</td><td>this string is inserted at the end of each line</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setItemNoSessionKey(String) itemNoSessionKey}</td><td>key of session variable to store number of item processed.</td><td>&nbsp;</td></tr>
 * <tr><td>{@link #setAddInputToResult(boolean) addInputToResult}</td><td>when <code>true</code> the input is added to the result in an input element</td><td>false</td></tr>
 * <tr><td>{@link #setRemoveDuplicates(boolean) removeDuplicates}</td><td>when <code>true</code> duplicate input elements are removed</td><td>false</td></tr>
 * </table>
 * <table border="1">
 * <tr><th>nested elements</th><th>description</th></tr>
 * <tr><td>{@link nl.nn.adapterframework.core.ISender sender}</td><td>specification of sender to send messages with</td></tr>
 * <tr><td>{@link nl.nn.adapterframework.core.ICorrelatedPullingListener listener}</td><td>specification of listener to listen to for replies</td></tr>
 * <tr><td>{@link nl.nn.adapterframework.parameters.Parameter param}</td><td>any parameters defined on the pipe will be handed to the sender, if this is a {@link nl.nn.adapterframework.core.ISenderWithParameters ISenderWithParameters}</td></tr>
 * <tr><td><code>inputValidator</code></td><td>specification of Pipe to validate input messages</td></tr>
 * <tr><td><code>outputValidator</code></td><td>specification of Pipe to validate output messages</td></tr>
 * <tr><td>{@link nl.nn.adapterframework.core.ITransactionalStorage messageLog}</td><td>log of all messages sent</td></tr>
 * </table>
 * </p>
 * <p><b>Exits:</b>
 * <table border="1">
 * <tr><th>state</th><th>condition</th></tr>
 * <tr><td>"success"</td><td>default when a good message was retrieved (synchronous sender), or the message was successfully sent and no listener was specified and the sender was not synchronous</td></tr>
 * <tr><td><i>{@link #setForwardName(String) forwardName}</i></td><td>if specified, and otherwise under same condition as "success"</td></tr>
 * <tr><td>"timeout"</td><td>no data was received (timeout on listening), if the sender was synchronous or a listener was specified.</td></tr>
 * <tr><td>"exception"</td><td>an exception was thrown by the Sender or its reply-Listener. The result passed to the next pipe is the exception that was caught.</td></tr>
 * </table>
 * </p>
 * <br>
 * The output of each of the processing of each of the elements is returned in XML as follows:
 * <pre>
 *  &lt;results count="num_of_elements"&gt;
 *    &lt;result&gt;result of processing of first item&lt;/result&gt;
 *    &lt;result&gt;result of processing of second item&lt;/result&gt;
 *       ...
 *  &lt;/results&gt;
 * </pre>
 *
 * 
 * For more configuration options, see {@link MessageSendingPipe}.
 * <br>
 * use parameters like:
 * <pre>
 *	&lt;param name="element-name-of-current-item"  xpathExpression="name(/*)" /&gt;
 *	&lt;param name="value-of-current-item"         xpathExpression="/*" /&gt;
 * </pre>
 * 
 * @author  Gerrit van Brakel
 * @since   4.7
 */
public abstract class IteratingPipe extends MessageSendingPipe {
	private TaskExecutor taskExecutor;
	private boolean parallel = false;

	private String stopConditionXPathExpression=null;
	private boolean removeXmlDeclarationInResults=false;
	private boolean collectResults=true;
	private String xpathExpression=null;
	private String namespaceDefs = null; 
	private String outputType="text";
	private String styleSheetName;
	private boolean omitXmlDeclaration=true;
	private String itemNoSessionKey=null;
	private boolean addInputToResult=false;
	private boolean removeDuplicates=false;
	
	private boolean ignoreExceptions=false;

	private boolean closeIteratorOnExit=true;
	
	private String blockPrefix="<block>";
	private String blockSuffix="</block>";
	private int blockSize=0;
	private String linePrefix="";
	private String lineSuffix="";

	private int startPosition=-1;
	private int endPosition=-1;

	protected TransformerPool msgTransformerPool;
	private TransformerPool stopConditionTp=null;

	protected String makeEncapsulatingXslt(String rootElementname,String xpathExpression) {
		return 
		"<xsl:stylesheet xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" version=\"1.0\" xmlns:xalan=\"http://xml.apache.org/xslt\">" +
		"<xsl:output method=\"xml\" omit-xml-declaration=\"yes\"/>" +
		"<xsl:strip-space elements=\"*\"/>" +
		"<xsl:template match=\"/\">" +
		"<xsl:element name=\"" + rootElementname + "\">" +
		"<xsl:copy-of select=\"" + xpathExpression + "\"/>" +
		"</xsl:element>" +
		"</xsl:template>" +
		"</xsl:stylesheet>";
	}

	private StatisticsKeeper senderStatisticsKeeper;

	public void configure() throws ConfigurationException {
		super.configure();
		msgTransformerPool = TransformerPool.configureTransformer(getLogPrefix(null), getNamespaceDefs(), getXpathExpression(), getStyleSheetName(), getOutputType(), !isOmitXmlDeclaration(), getParameterList(), false);
		try {
			if (StringUtils.isNotEmpty(getStopConditionXPathExpression())) {
				stopConditionTp=new TransformerPool(XmlUtils.createXPathEvaluatorSource(null,getStopConditionXPathExpression(),"xml",false));
			}
		} catch (TransformerConfigurationException e) {
			throw new ConfigurationException(e);
		}
	}

	protected IDataIterator getIterator(Object input, IPipeLineSession session, String correlationID, Map threadContext) throws SenderException {
		return null;
	}

	protected void iterateInput(Object input, IPipeLineSession session, String correlationID, Map threadContext, ItemCallback callback) throws SenderException, TimeOutException {
		 throw new SenderException("Could not obtain iterator and no iterateInput method provided by class ["+ClassUtils.nameOf(this)+"]");
	}

	protected class ItemCallback {
		private IPipeLineSession session;
		private String correlationID;
		private ISender sender; 
		private ISenderWithParameters psender=null;
		private StringBuffer results = new StringBuffer();
		int count=0;
		private Vector inputItems = new Vector();
		private Guard guard;
		List<SenderExecutor> executorList;

		public ItemCallback(IPipeLineSession session, String correlationID, ISender sender) {
			this.session=session;
			this.correlationID=correlationID;
			this.sender=sender;
			if (sender instanceof ISenderWithParameters && getParameterList()!=null) {
				psender = (ISenderWithParameters) sender;
			}
			if (isParallel() && isCollectResults()) {
				guard = new Guard();
				executorList = new ArrayList();
			}
		}
		public boolean handleItem(String item) throws SenderException, TimeOutException {
			if (isParallel() && isCollectResults()) {
				guard.addResource();
			}
			if (isRemoveDuplicates()) {
				if (inputItems.indexOf(item)>=0) {
					log.debug(getLogPrefix(session)+"duplicate item ["+item+"] will not be processed");
					return true;
				} else {
					inputItems.add(item);
				}
			}
			String itemResult=null;
			count++;
			if (StringUtils.isNotEmpty(getItemNoSessionKey())) {
				session.put(getItemNoSessionKey(),""+count);
			}
			ParameterResolutionContext prc=null;
			// TODO check for bug: sessionKey params not resolved when only parameters set on sender. Next line should check sender.parameterlist too.
			if (psender !=null || msgTransformerPool!=null && getParameterList()!=null) {
				//TODO find out why ParameterResolutionContext cannot be constructed using dom-source
				prc = new ParameterResolutionContext(item, session, isNamespaceAware());
			}
			if (msgTransformerPool!=null) {
				try {
					String transformedMsg=msgTransformerPool.transform(item,prc!=null?prc.getValueMap(getParameterList()):null);
					if (log.isDebugEnabled()) {
						log.debug(getLogPrefix(session)+"iteration ["+count+"] transformed item ["+item+"] into ["+transformedMsg+"]");
					}
					item=transformedMsg;
				} catch (Exception e) {
					throw new SenderException(getLogPrefix(session)+"cannot transform item",e);
				}
			} else {
				if (log.isDebugEnabled()) {
					log.debug(getLogPrefix(session)+"iteration ["+count+"] item ["+item+"]");
				} 
			}
			try {
				if (isParallel()) {
					SenderExecutor se= new SenderExecutor(sender, correlationID,
							item, prc, guard, senderStatisticsKeeper);
					if (isCollectResults()) {
						executorList.add(se);
					}
					getTaskExecutor().execute(se);
				} else {
					if (psender!=null) {
						itemResult = psender.sendMessage(correlationID, item, prc);
					} else {
						itemResult = sender.sendMessage(correlationID, item);
					}
				}
				if (StringUtils.isNotEmpty(getTimeOutOnResult()) && getTimeOutOnResult().equals(itemResult)) {
					throw new TimeOutException(getLogPrefix(session)+"timeOutOnResult ["+getTimeOutOnResult()+"]");
				}
				if (StringUtils.isNotEmpty(getExceptionOnResult()) && getExceptionOnResult().equals(itemResult)) {
					throw new SenderException(getLogPrefix(session)+"exceptionOnResult ["+getExceptionOnResult()+"]");
				}
			} catch (SenderException e) {
				if (isIgnoreExceptions()) {
					log.info(getLogPrefix(session)+"ignoring SenderException after excution of sender for item ["+item+"]",e);
					itemResult="<exception>"+XmlUtils.encodeChars(e.getMessage())+"</exception>";
				} else {
					throw e;
				}
			} catch (TimeOutException e) {
				if (isIgnoreExceptions()) {
					log.info(getLogPrefix(session)+"ignoring TimeOutException after excution of sender for item ["+item+"]",e);
					itemResult="<timeout>"+XmlUtils.encodeChars(e.getMessage())+"</timeout>";
				} else {
					throw e;
				}
			}
			try {
				if (isCollectResults() && !isParallel()) {
					addResult(count, item, itemResult);
				}
				if (getStopConditionTp()!=null) {
					String stopConditionResult = getStopConditionTp().transform(itemResult,null);
					if (StringUtils.isNotEmpty(stopConditionResult) && !stopConditionResult.equalsIgnoreCase("false")) {
						log.debug(getLogPrefix(session)+"stopcondition result ["+stopConditionResult+"], stopping loop");
						return false;
					} else {
						log.debug(getLogPrefix(session)+"stopcondition result ["+stopConditionResult+"], continueing loop");
					}
				}
				return true;
			} catch (DomBuilderException e) {
				throw new SenderException(getLogPrefix(session)+"cannot parse input",e);
			} catch (TransformerException e) {
				throw new SenderException(getLogPrefix(session)+"cannot serialize item",e);
			} catch (IOException e) {
				throw new SenderException(getLogPrefix(session)+"cannot serialize item",e);
			}
		}
		private void addResult(int count, String item, String itemResult) {
			if (isRemoveXmlDeclarationInResults()) {
				if (log.isDebugEnabled()) log.debug(getLogPrefix(session)+"removing XML declaration from ["+itemResult+"]");
				itemResult = XmlUtils.skipXmlDeclaration(itemResult);
			} 
			if (log.isDebugEnabled()) log.debug(getLogPrefix(session)+"partial result ["+itemResult+"]");
			String itemInput="";
			if (isAddInputToResult()) {
				itemInput = "<input>"+(isRemoveXmlDeclarationInResults()?XmlUtils.skipXmlDeclaration(item):item)+"</input>";
			}
			itemResult = "<result item=\"" + count + "\">\n"+itemInput+itemResult+"\n</result>";
			results.append(itemResult+"\n");
		}
		public StringBuffer getResults() throws SenderException {
			if (isParallel()) {
				try {
					guard.waitForAllResources();
					int count = 0;
					for (SenderExecutor se : executorList) {
						count++;
						String itemResult;
						if (se.getThrowable() == null) {
							itemResult = se.getReply().toString();
						} else {
							itemResult = "<exception>"+XmlUtils.encodeChars(se.getThrowable().getMessage())+"</exception>";
						}
						addResult(count, se.getRequest().toString(), itemResult);
					}
				} catch (InterruptedException e) {
					throw new SenderException(getLogPrefix(session)+"was interupted",e);
				}
			}
			return results;
		}
		public int getCount() {
			return count;
		}
	}

	protected String sendMessage(Object input, IPipeLineSession session, String correlationID, ISender sender, Map threadContext) throws SenderException, TimeOutException {
		// sendResult has a messageID for async senders, the result for sync senders
		boolean keepGoing = true;
		IDataIterator it=null;
		try {
			ItemCallback callback = new ItemCallback(session,correlationID,sender);
			it = getIterator(input,session, correlationID,threadContext);
			if (it==null) {
				iterateInput(input,session,correlationID, threadContext, callback);
			} else {
				String nextItemStored = null;
				while (keepGoing && (it.hasNext() || nextItemStored!=null)) {
					if (Thread.currentThread().isInterrupted()) {
						throw new TimeOutException("Thread has been interrupted");
					}
					StringBuffer items = new StringBuffer();
					if (getBlockSize()>0) {
						items.append(getBlockPrefix());
						for (int i=0; i<getBlockSize() && it.hasNext(); i++) {
							String item = (String)it.next();
							items.append(getLinePrefix());
							items.append(item);
							items.append(getLineSuffix());
						}
						items.append(getBlockSuffix());
 						keepGoing = callback.handleItem(items.toString()); 
						
					} else {
						if (getStartPosition()>=0 && getEndPosition()>getStartPosition()) {
							items.append(getBlockPrefix());
							String keyPreviousItem = null;
							boolean sameKey = true;
							while (sameKey && (it.hasNext() || nextItemStored!=null)) {
								String item;
								if (nextItemStored==null) {
									item = (String)it.next();
								} else {
									item = nextItemStored;
									nextItemStored = null;
								}
								String key;
								if (getEndPosition() >= item.length()) {
									key = item.substring(getStartPosition());
								}
								else {
									key = item.substring(getStartPosition(), getEndPosition());
								}
								if (keyPreviousItem==null || key.equals(keyPreviousItem)) {
									items.append(getLinePrefix());
									items.append(item);
									items.append(getLineSuffix());
									if (keyPreviousItem==null) {
										keyPreviousItem = key;
									}
								} else {
									sameKey = false;
									nextItemStored = item;
								}
							}
							items.append(getBlockSuffix());
	 						keepGoing = callback.handleItem(items.toString()); 
						} else {
							String item = getItem(it);
							items.append(getLinePrefix());
							items.append(item);
							items.append(getLineSuffix());
							keepGoing = callback.handleItem(item); 
						}
					}
				}
			}
			String results = "";
			if (isCollectResults()) {
				StringBuffer callbackResults = callback.getResults();
				callbackResults.insert(0, "<results count=\""+callback.getCount()+"\">\n");
				callbackResults.append("</results>");
				results = callbackResults.toString();
			} else {
				results = "<results count=\""+callback.getCount()+"\"/>";
			}
			return results;
		} finally {
			if (it!=null) {
				try {
					if (isCloseIteratorOnExit()) {
						it.close();
					}
				} catch (Exception e) {
					log.warn("Exception closing iterator", e);
				} 
			}
		}
	}

	protected String getItem(IDataIterator it) throws SenderException {
		return (String)it.next();
	}

	@Override
	public void iterateOverStatistics(StatisticsKeeperIterationHandler hski, Object data, int action) throws SenderException {
		super.iterateOverStatistics(hski, data, action);
		hski.handleStatisticsKeeper(data, senderStatisticsKeeper);
	}

	public void setSender(Object sender) {
		if (sender instanceof ISender) {
			super.setSender((ISender)sender);
		} else {
			throw new IllegalArgumentException("sender ["+ClassUtils.nameOf(sender)+"] must implment interface ISender");
		}
		senderStatisticsKeeper =  new StatisticsKeeper("-> "+ClassUtils.nameOf(sender));
	}

	public void setTaskExecutor(TaskExecutor executor) {
		taskExecutor = executor;
	}
	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setParallel(boolean parallel) {
		this.parallel = parallel;
	}
	public boolean isParallel() {
		return parallel;
	}

	public void setStopConditionXPathExpression(String string) {
		stopConditionXPathExpression = string;
	}
	public String getStopConditionXPathExpression() {
		return stopConditionXPathExpression;
	}


	public void setRemoveXmlDeclarationInResults(boolean b) {
		removeXmlDeclarationInResults = b;
	}
	public boolean isRemoveXmlDeclarationInResults() {
		return removeXmlDeclarationInResults;
	}

	public void setCollectResults(boolean b) {
		collectResults = b;
	}
	public boolean isCollectResults() {
		return collectResults;
	}

	protected TransformerPool getStopConditionTp() {
		return stopConditionTp;
	}


	public void setStyleSheetName(String stylesheetName){
		this.styleSheetName=stylesheetName;
	}
	public String getStyleSheetName() {
		return styleSheetName;
	}

	public void setOmitXmlDeclaration(boolean b) {
		omitXmlDeclaration = b;
	}
	public boolean isOmitXmlDeclaration() {
		return omitXmlDeclaration;
	}


	public void setXpathExpression(String string) {
		xpathExpression = string;
	}
	public String getXpathExpression() {
		return xpathExpression;
	}

	public void setNamespaceDefs(String namespaceDefs) {
		this.namespaceDefs = namespaceDefs;
	}
	public String getNamespaceDefs() {
		return namespaceDefs;
	}

	public void setOutputType(String string) {
		outputType = string;
	}
	public String getOutputType() {
		return outputType;
	}


	public void setIgnoreExceptions(boolean b) {
		ignoreExceptions = b;
	}
	public boolean isIgnoreExceptions() {
		return ignoreExceptions;
	}

	public void setBlockPrefix(String string) {
		blockPrefix = string;
	}
	public String getBlockPrefix() {
		return blockPrefix;
	}

	public void setLinePrefix(String string) {
		linePrefix = string;
	}
	public String getLinePrefix() {
		return linePrefix;
	}

	public void setBlockSuffix(String string) {
		blockSuffix = string;
	}
	public String getBlockSuffix() {
		return blockSuffix;
	}

	public void setLineSuffix(String string) {
		lineSuffix = string;
	}
	public String getLineSuffix() {
		return lineSuffix;
	}

	public void setBlockSize(int i) {
		blockSize = i;
	}
	public int getBlockSize() {
		return blockSize;
	}

	public void setItemNoSessionKey(String string) {
		itemNoSessionKey = string;
	}
	public String getItemNoSessionKey() {
		return itemNoSessionKey;
	}

	public void setAddInputToResult(boolean b) {
		addInputToResult = b;
	}
	public boolean isAddInputToResult() {
		return addInputToResult;
	}

	public void setRemoveDuplicates(boolean b) {
		removeDuplicates = b;
	}
	public boolean isRemoveDuplicates() {
		return removeDuplicates;
	}

	protected void setCloseIteratorOnExit(boolean b) {
		closeIteratorOnExit = b;
	}
	protected boolean isCloseIteratorOnExit() {
		return closeIteratorOnExit;
	}
	public void setStartPosition(int i) {
		startPosition = i;
	}
	public int getStartPosition() {
		return startPosition;
	}

	public void setEndPosition(int i) {
		endPosition = i;
	}
	public int getEndPosition() {
		return endPosition;
	}
}
