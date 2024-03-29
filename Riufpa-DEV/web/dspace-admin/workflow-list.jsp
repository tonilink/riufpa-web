<%--
  - workflow_list.jsp
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
  - Display list of Workflows, with 'abort' buttons next to them
  -
  - Attributes:
  -
  -   workflows - WorkflowItem [] to choose from
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.administer.DCType" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>

<%
    WorkflowItem[] workflows =
            (WorkflowItem[]) request.getAttribute("workflows");
%>

<dspace:layout titlekey="jsp.dspace-admin.workflow-list.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>
    <style type="text/css">
        .tabela{
            margin-top: 0px !important;
        }
    </style>

    <table class="tabela">
        <tr>
            <td class="tituloTabela" colspan="5">
                <fmt:message key="jsp.dspace-admin.workflow-list.heading"/>
            </td>
        </tr>
        <tr>
            <th>ID</th>
            <th><fmt:message key="jsp.dspace-admin.workflow-list.collection"/></th>
            <th><fmt:message key="jsp.dspace-admin.workflow-list.submitter"/></th>
            <th><fmt:message key="jsp.dspace-admin.workflow-list.item-title"/></th>
            <th><fmt:message key="jsp.dspace-admin.workflow-list.acao"/></th>
        </tr>
        <%
            for (int i = 0; i < workflows.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr class="stripe">
            <%            } else {
            %>
        <tr>
            <%                }
            %>
            <td>
                <%= workflows[i].getID()%>
            </td>
            <td>
                <%= workflows[i].getCollection().getMetadata("name")%>
            </td>
            <td>
                <%= workflows[i].getSubmitter().getFullName()%>
                <br />
                (<%= workflows[i].getSubmitter().getEmail()%>)
            </td>
            <td>
                <%= Utils.addEntities(WorkflowManager.getItemTitle(workflows[i]))%>
            </td>
            <td>
                <form method="post" action="">
                    <input type="hidden" name="workflow_id" value="<%= workflows[i].getID()%>"/>
                    <input type="submit" class="buttonRed" name="submit_abort" value="<fmt:message key="jsp.dspace-admin.general.abort-w-confirm"/>" />
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</dspace:layout>
