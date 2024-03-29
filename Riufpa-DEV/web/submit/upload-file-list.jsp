<%--
  - upload-file-list.jsp
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
  - List of uploaded files
  -
  - Attributes to pass in to this page:
  -   just.uploaded     - Boolean indicating if a file has just been uploaded
  -                       so a nice thank you can be displayed.
  -   show.checksums    - Boolean indicating whether to show checksums
  -
  - FIXME: Assumes each bitstream in a separate bundle.
  -        Shouldn't be a problem for early adopters.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Bitstream" %>
<%@ page import="org.dspace.content.BitstreamFormat" %>
<%@ page import="org.dspace.content.Bundle" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

    //get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

    boolean justUploaded = ((Boolean) request.getAttribute("just.uploaded")).booleanValue();
    boolean showChecksums = ((Boolean) request.getAttribute("show.checksums")).booleanValue();

    request.setAttribute("LanguageSwitch", "hide");
%>

<dspace:layout locbar="off" navbar="off" titlekey="jsp.submit.upload-file-list.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp"/>

        <div class="formularioDesc">

            <%
                if (justUploaded) {
            %>
            <h3><fmt:message key="jsp.submit.upload-file-list.heading1"/></h3>
            <%--
            <p><fmt:message key="jsp.submit.upload-file-list.info1"/></p>
            --%>
            <%
                } else {
            %>
            <h3><fmt:message key="jsp.submit.upload-file-list.heading2"/></h3>
            <%
                }
            %>
            <div>
                <%--
                <p>
                <fmt:message key="jsp.submit.upload-file-list.info2"/>
                </p>
                <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, "help.index\") + \"#uploadedfile\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup></div>
                --%>

            <table id="listaArquivos">
                <tr>
                    <td colspan="7" id="tituloTabela">Arquivos enviados</td>
                </tr>
                <tr>
                    <th id="t1"> <fmt:message key="jsp.submit.upload-file-list.tableheading1"/> </th>
                    <th id="t2"> <fmt:message key="jsp.submit.upload-file-list.tableheading2"/> </th>
                    <th id="t3"> <fmt:message key="jsp.submit.upload-file-list.tableheading3"/> </th>
                    <th id="t4"> <fmt:message key="jsp.submit.upload-file-list.tableheading4"/> </th>
                    <th id="t5"> <fmt:message key="jsp.submit.upload-file-list.tableheading5"/> </th>
                    <%
                        if (showChecksums) {
                    %>
                    <th id="t6"> <fmt:message key="jsp.submit.upload-file-list.tableheading6"/> </th>
                    <%
                        }
                        // Don't display last column ("Remove") in workflow mode
                        if (!subInfo.isInWorkflow()) {
                            // Whether it's an odd or even column depends on whether we're showing checksums
                            //String column = (showChecksums ? "Even" : "Odd");
                    %>
                    <th id="t7">&nbsp;</th>
                    <%
                        }
                    %>
                </tr>

                <%
                    String row = "even";

                    Bitstream[] bitstreams = subInfo.getSubmissionItem().getItem().getNonInternalBitstreams();
                    Bundle[] bundles = null;

                    if (bitstreams[0] != null) {
                        bundles = bitstreams[0].getBundles();
                    }

                    for (int i = 0; i < bitstreams.length; i++) {
                        BitstreamFormat format = bitstreams[i].getFormat();
                        String description = bitstreams[i].getFormatDescription();
                        String supportLevel = LocaleSupport.getLocalizedMessage(pageContext, "jsp.submit.upload-file-list.supportlevel1");

                        if (format.getSupportLevel() == 1) {
                            supportLevel = LocaleSupport.getLocalizedMessage(pageContext, "jsp.submit.upload-file-list.supportlevel2");
                        }

                        if (format.getSupportLevel() == 0) {
                            supportLevel = LocaleSupport.getLocalizedMessage(pageContext, "jsp.submit.upload-file-list.supportlevel3");
                        }

                        // Full param to dspace:popup must be single variable
                        String supportLevelLink = LocaleSupport.getLocalizedMessage(pageContext, "help.formats") + "#" + supportLevel;
                %>
                <tr>
                    <td headers="t1">
                        <input type="radio" name="primary_bitstream_id" value="<%= bitstreams[i].getID()%>"
                               <% if (bundles[0] != null) {
                                       if (bundles[0].getPrimaryBitstreamID() == bitstreams[i].getID()) {%>
                               <%="checked='checked'"%>
                               <%   }
                                   }%> />
                    </td>
                    <td headers="t2">
                        <a href="<%= request.getContextPath()%>/retrieve/<%= bitstreams[i].getID()%>/<%= org.dspace.app.webui.util.UIUtil.encodeBitstreamName(bitstreams[i].getName())%>" target="_blank"><%= bitstreams[i].getName()%></a>
                    </td>
                    <td headers="t3">
                        <%= bitstreams[i].getSize()%> bytes
                    </td>
                    <td headers="t4">
                        <%= (bitstreams[i].getDescription() == null || bitstreams[i].getDescription().equals("")
                                ? LocaleSupport.getLocalizedMessage(pageContext, "jsp.submit.upload-file-list.empty1")
                                : bitstreams[i].getDescription())%>
                        <input type="submit" name="submit_describe_<%= bitstreams[i].getID()%>" class="button"
                               value="<fmt:message key="jsp.submit.upload-file-list.button1"/>" />
                    </td>
                    <td headers="t5">
                        <%= description%> <dspace:popup page="<%= supportLevelLink%>">(<%= supportLevel%>)</dspace:popup>
                        <input type="submit" name="submit_format_<%= bitstreams[i].getID()%>" class="button"
                               value="<fmt:message key="jsp.submit.upload-file-list.button1"/>" />
                    </td>
                    <%
                        // Checksum
                        if (showChecksums) {
                    %>
                    <td headers="t6">
                        <code><%= bitstreams[i].getChecksum()%> (<%= bitstreams[i].getChecksumAlgorithm()%>)</code>
                    </td>
                    <%
                        }
                        // Don't display "remove" button in workflow mode
                        if (!subInfo.isInWorkflow()) {
                            // Whether it's an odd or even column depends on whether we're showing checksums
                            String column = (showChecksums ? "Even" : "Odd");
                    %>
                    <td headers="t7">
                        <input type="submit" name="submit_remove_<%= bitstreams[i].getID()%>" class="button"
                               value="<fmt:message key="jsp.submit.upload-file-list.button2"/>" />
                    </td>
                    <%
                        }
                    %>
                </tr>
                <%
                        row = (row.equals("even") ? "odd" : "even");
                    }
                %>
            </table>

            <%-- HACK:  Need a space - is there a nicer way to do this than <br> or a --%>
            <%--        blank <p>? --%>
            <br />

            <%-- Show information about how to verify correct upload, but not in workflow
                 mode! --%>
            <%
                if (!subInfo.isInWorkflow()) {
            %>
            <p><fmt:message key="jsp.submit.upload-file-list.info3"/></p>
            <ul>
                <li><fmt:message key="jsp.submit.upload-file-list.info4"/></li>
                <%
                    if (showChecksums) {
                %>
                <li>
                    <fmt:message key="jsp.submit.upload-file-list.info5"/>
                    <%--
                    <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#checksum\"%>"><fmt:message key="jsp.submit.upload-file-list.help1"/></dspace:popup></li>
                    --%>
                    <%
                        } else {
                    %>
                <li>
                    <fmt:message key="jsp.submit.upload-file-list.info6"/>
                    <%--
                    <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, "help.index\") + \"#checksum\"%>"><fmt:message key="jsp.submit.upload-file-list.help2"/></dspace:popup> <input type="submit" name="submit_show_checksums" value="<fmt:message key="jsp.submit.upload-file-list.button3"/>" />
                    --%>
                </li>
                    <%
                            }
                    %>
            </ul>
            <br />
            <%
                }
            %>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <div id="controles">
                <div class="direita">
                    <input type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.upload-file-list.button7"/>" />
                </div>
                <div class="esquerda">

                    <%
                    if (!showChecksums) {
                %>
                    <input type="submit" name="submit_show_checksums" class="button"
                           value="<fmt:message key="jsp.submit.upload-file-list.button3"/>"/>

                    <%
                                       }
                        // Don't allow files to be added in workflow mode
                        if (!subInfo.isInWorkflow()) {
                    %>
                    <input type="submit" name="submit_more" class="button"
                           value="<fmt:message key="jsp.submit.upload-file-list.button4"/>" />
                    <%
                        }
                    %>
                    <%  //if not first step, show "Previous" button
                        if (!SubmissionController.isFirstStep(request, subInfo)) {
                    %>
                    <input type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.upload-file-list.button5"/>" />
                    <%
                        }
                    %>
                    <input type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.upload-file-list.button6"/>" />
                </div>
            </div>

        </div>
    </form>

</dspace:layout>
