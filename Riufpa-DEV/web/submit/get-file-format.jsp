<%--
  - get-file-format.jsp
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
  - Select type of uploaded file
  -
  - Attributes to pass in to this page:
  -    guessed.format     - the system's guess as to the format - null if it
  -                         doesn't know (BitstreamFormat)
  -    bitstream.formats  - the (non-internal) formats known by the system
  -                         (BitstreamFormat[])
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Bitstream" %>
<%@ page import="org.dspace.content.BitstreamFormat" %>
<%@ page import="org.dspace.content.Bundle" %>
<%@ page import="org.dspace.content.Item" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

    //get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

    //retrieve attributes from request
    BitstreamFormat guess =
            (BitstreamFormat) request.getAttribute("guessed.format");
    BitstreamFormat[] formats =
            (BitstreamFormat[]) request.getAttribute("bitstream.formats");

    Item item = subInfo.getSubmissionItem().getItem();
%>

<dspace:layout locbar="off" navbar="off" titlekey="jsp.submit.get-file-format.title" nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp"/>

        <div class="formularioDesc">

            <h3><fmt:message key="jsp.submit.get-file-format.heading"/></h3>

            <p>
                <fmt:message key="jsp.submit.get-file-format.info1">
                    <fmt:param><%= subInfo.getBitstream().getName()%></fmt:param>
                    <fmt:param><%= String.valueOf(subInfo.getBitstream().getSize())%></fmt:param>
                </fmt:message>
            </p>

            <%
                if (guess == null) {
            %>
            <p>
                <fmt:message key="jsp.submit.get-file-format.info2"/>
            </p>
            <%            } else {
            %>
            <%-- Advinhar o formato. Geralmente quando a submissão tem só um documento. --%>

            <p>
                <fmt:message key="jsp.submit.get-file-format.info3">
                    <fmt:param><%= guess.getShortDescription()%></fmt:param>
                </fmt:message>
            </p>
            <input type="hidden" name="format" value="<%= guess.getID()%>" />

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <%-- <p align="center"><input type="submit" name="submit" value="Choose automatically-recognized type"></p> --%>
            <p style="text-align: center;">
                <input type="submit" name="submit" class="button"
                       value="<fmt:message key="jsp.submit.get-file-format.choose.button"/>" />
            </p>
    </form>

    <%-- Option list put in a separate form --%>
    <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">
        <%
            }
        %>
        <p>
            <fmt:message key="jsp.submit.get-file-format.info5"/>
        </p>
        <%--
        <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, "help.index\") + \"#formats\" %>"><fmt:message key="jsp.morehelp"/></dspace:popup></div>
        --%>

        <center>
            <select name="format" size="8">
                <option value="-1" <%= subInfo.getBitstream().getFormat().getShortDescription().equals("Unknown") ? "selected=\"selected\"" : ""%>>
                    <fmt:message key="jsp.submit.get-file-format.info6"/>
                </option>
                <%
                    for (int i = 0; i < formats.length; i++) {
                %>
                <option
                    <%= subInfo.getBitstream().getFormat().getID() == formats[i].getID() ? "selected=\"selected\"" : ""%>
                    value="<%= formats[i].getID()%>">
                    <%= formats[i].getShortDescription()%>
                    <%
                        if (formats[i].getSupportLevel() == 1) {
                    %>
                    <fmt:message key="jsp.submit.get-file-format.known"/>
                    <%                        }
                        if (formats[i].getSupportLevel() == 2) {
                    %>
                    <fmt:message key="jsp.submit.get-file-format.supported"/>
                    <%                        }
                    %>
                </option>
                <%
                    }
                %>
            </select>
        </center>

        <p><fmt:message key="jsp.submit.get-file-format.info7"/></p>

        <p style="text-align: center;">
                    <label for="tformat_description"><fmt:message key="jsp.submit.get-file-format.format"/></label>

                    <%
                        String desc = subInfo.getBitstream().getUserFormatDescription();
                        if (desc == null) {
                            desc = "";
                        }
                    %>
                    <input type="text" name="format_description" id="tformat_description" size="40" value="<%= desc%>" />
        </p>


        <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
        <%= SubmissionController.getSubmissionParameters(context, request)%>

        <p style="text-align: center;">
            <input type="submit" name="submit" class="button"
                   value="<fmt:message key="jsp.submit.get-file-format.alterar"/>" />
        </p>

    </div>
</form>
</dspace:layout>
