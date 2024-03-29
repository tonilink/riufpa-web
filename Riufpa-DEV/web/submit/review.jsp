<%--
  - review.jsp
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

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.io.IOException" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="javax.servlet.jsp.PageContext" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.util.DCInputSet" %>
<%@ page import="org.dspace.app.util.DCInput" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Bitstream" %>
<%@ page import="org.dspace.content.BitstreamFormat" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.content.DCLanguage" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.InProgressSubmission" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.core.Utils" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

    //get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

    //get list of review JSPs from VerifyServlet
    HashMap reviewJSPs = (HashMap) request.getAttribute("submission.review");

    //get an iterator to loop through the review JSPs to load
    Iterator reviewIterator = reviewJSPs.keySet().iterator();
%>

<dspace:layout locbar="off" navbar="off" titlekey="jsp.submit.review.title" nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp" />

        <div class="formularioDesc">

            <h3><fmt:message key="jsp.submit.review.heading"/></h3>

            <%--
            <p><fmt:message key="jsp.submit.review.info1"/></p>
            --%>

            <p><fmt:message key="jsp.submit.review.info2"/></p>

            <%--
        &nbsp;&nbsp;<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#verify\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup></div>
            --%>

            <p><fmt:message key="jsp.submit.review.info3"/></p>

            <%--
            <p><fmt:message key="jsp.submit.review.info4"/></p>
            --%>

            <table style="margin-left:auto; margin-right:auto; width:100%;">
                <tr>
                    <td>
                        <hr/>
                    </td>
                </tr>
                <%
                    //loop through the list of review JSPs
                    while (reviewIterator.hasNext()) {
                        //remember, the keys of the reviewJSPs hashmap is in the
                        //format: stepNumber.pageNumber
                        String stepAndPage = (String) reviewIterator.next();

                        //finally get the path to the review JSP (the value)
                        String reviewJSP = (String) reviewJSPs.get(stepAndPage);
                %>
                <tr>
                    <td>
                        <%--Load the review JSP and pass it step & page info--%>
                        <jsp:include page="<%=reviewJSP%>">
                            <jsp:param name="submission.jump" value="<%=stepAndPage%>" />
                        </jsp:include>
                    </td>
                </tr>
                <tr>
                    <td>
                        <hr/>
                    </td>
                </tr>
                <%
                    }

                %>
            </table>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <div id="controles">
                <div class="direita">
                    <input type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.review.button.cancelsave"/>" />
                </div>
                <div class="esquerda">
                    <input type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.review.button.previous"/>" />
                    <input type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.review.button.next"/>" />
                </div>
            </div>


        </div>

    </form>

</dspace:layout>
