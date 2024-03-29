<%--
  - initial-questions.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
--%>

<%--
  - Initial questions for keeping UI as simple as possible.
  -
  - Attributes to pass in:
  -    submission.info    - the SubmissionInfo object
  -    submission.inputs  - the DCInputSet object
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.util.DCInputSet" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    DCInputSet inputSet =
            (DCInputSet) request.getAttribute("submission.inputs");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

    //get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);
%>

<dspace:layout locbar="off"
               navbar="off"
               titlekey="jsp.submit.initial-questions.title"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp" />

        <div class="formularioDesc">

            <h3><fmt:message key="jsp.submit.initial-questions.heading"/></h3>

            <div id="mensagem">
                <fmt:message key="jsp.submit.initial-questions.info" />
                <%--
                <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext,
                \"help.index\") + \"#describe1\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup>
                --%>
            </div>

            <center>
                <table>
                    <%
                        // Don't display MultipleTitles if no such form box defined
                        if (inputSet.isDefinedMultTitles()) {
                    %>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <input type="checkbox" name="multiple_titles" id="multiple_titles" value="true"
                                               <%= (subInfo.getSubmissionItem().hasMultipleTitles() ? "checked='checked'" : "")%> />
                                    </td>
                                    <td>
                                        <label for="multiple_titles">
                                            <fmt:message key="jsp.submit.initial-questions.elem1"/>
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%
                        }
                        // Don't display PublishedBefore if no form boxes defined
                        if (inputSet.isDefinedPubBefore()) {
                    %>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td style="display: none;">
                                        <%--
                                        <input type="checkbox" name="published_before" value="true" <%= (subInfo.getSubmissionItem().isPublishedBefore() ? "checked='checked'" : "") %> />
                                        --%>
                                        <input type="checkbox" name="published_before" id="published_before" value="true" checked="checked"> />
                                    </td>
                                    <td style="display: none;">
                                        <label for="published_before">
                                            <fmt:message key="jsp.submit.initial-questions.elem2"/>
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%    }
                        // Don't display file or thesis questions in workflow mode
                        if (!subInfo.isInWorkflow()) {
                    %>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <input type="checkbox" name="multiple_files" id="multiple_files" value="true"
                                               <%= (subInfo.getSubmissionItem().hasMultipleFiles() ? "checked='checked'" : "")%> />
                                    </td>
                                    <td>
                                        <label for="multiple_files">
                                            <fmt:message key="jsp.submit.initial-questions.elem3"/>
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%
                        if (ConfigurationManager.getBooleanProperty("webui.submit.blocktheses")) {
                    %>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <input type="checkbox" name="is_thesis" id="is_thesis" value="true">
                                    </td>
                                    <td>
                                        <label for="is_thesis">
                                            <fmt:message key="jsp.submit.initial-questions.elem4"/>
                                        </label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%        }
                        }
                    %>
                </table>
            </center>

            <br /><br />

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <div id="controles">
                <div class="direita">
                    <input type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" class="button" value="<fmt:message key="jsp.submit.general.cancel-or-save.button"/>" />
                </div>
                <div class="esquerda">
                    <%
                        //if not first step, show "Previous" button
                        if (!SubmissionController.isFirstStep(request, subInfo)) {
                    %>
                    <input type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" class="button" value="<fmt:message key="jsp.submit.general.previous"/>" />
                    <%
                        }
                    %>
                    <input type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" class="button" value="<fmt:message key="jsp.submit.general.next"/>" />
                </div>
            </div>

        </div>
    </form>

</dspace:layout>
