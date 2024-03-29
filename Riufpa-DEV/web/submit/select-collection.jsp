<%--
  - select-collection.jsp
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
  - UI page for selection of collection.
  -
  - Required attributes:
  -    collections - Array of collection objects to show in the drop-down.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    //get collections to choose from
    Collection[] collections =
            (Collection[]) request.getAttribute("collections");

    //check if we need to display the "no collection selected" error
    Boolean noCollection = (Boolean) request.getAttribute("no.collection");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);
    
   
%>

<dspace:layout locbar="off"
               navbar="off"
               titlekey="jsp.submit.select-collection.title"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <div class="formularioDesc">
        <h3><fmt:message key="jsp.submit.select-collection.heading"/></h3>


        <%
            if (collections.length > 0) {
        %>
        <p class="centralizar">
            <fmt:message key="jsp.submit.select-collection.info1"/>
            <%--
            <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#choosecollection\"%>"><fmt:message key="jsp.morehelp"/> </dspace:popup>
            --%>
        </p>

        <form action="<%= request.getContextPath()%>/submit" method="post" onkeydown="return disableEnterKey(event);">
            <%
                //if no collection was selected, display an error
                if ((noCollection != null) && (noCollection.booleanValue() == true)) {
            %>
            <p class="centralizar submitFormWarn">
                <fmt:message key="jsp.submit.select-collection.no-collection"/>
            </p>
            <%
                }
            %>
            <div class="centralizar">
            <label for="tcollection">
                <fmt:message key="jsp.submit.select-collection.collection"/>
            </label>

            <select name="collection" id="tcollection">
                <option value="-1"></option>
                <%
                    for (int i = 0; i < collections.length; i++) {
                %>
                <option value="<%= collections[i].getID()%>"><%= collections[i].getMetadata("name")%></option>
                <%
                    }
                %>
            </select>
            </div>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>
            <br />

            <div id="controles">
                <div class="direita">
                    <input type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.select-collection.cancel"/>" />
                </div>
                <div class="esquerda">
                    <input type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.general.next"/>" />
                </div>
            </div>


        </form>
        <%
        } else {
        %>
        <p class="submitFormWarn">
            <fmt:message key="jsp.submit.select-collection.none-authorized"/>
        </p>
        <%
        }
        %>

        <%--
                   <p><fmt:message key="jsp.general.goto"/><br />
                   <a href="<%= request.getContextPath() %>"><fmt:message key="jsp.general.home"/></a><br />
                   <a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.general.mydspace" /></a>
                   </p>
        --%>

    </div>
</dspace:layout>
