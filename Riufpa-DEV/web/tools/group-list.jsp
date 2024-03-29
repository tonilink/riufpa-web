<%--
  - group_list.jsp
  -
  - $Id: group-list.jsp 3705 2009-04-11 17:02:24Z mdiggory $
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
  - Display list of Groups, with 'edit' and 'delete' buttons next to them
  -
  - Attributes:
  -
  -   groups - Group [] of groups to work on
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.eperson.Group" %>

<%
    Group[] groups =
        (Group[]) request.getAttribute("groups");
%>

<dspace:layout titlekey="jsp.tools.group-list.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css" />

    <h1><fmt:message key="jsp.tools.group-list.title"/></h1>

    <p><fmt:message key="jsp.tools.group-list.note1"/></p>
    <p><fmt:message key="jsp.tools.group-list.note2"/></p>

    <form method="post" action="">
        <p align="center">
            <input type="submit" class="button" name="submit_add" value="<fmt:message key="jsp.tools.group-list.create.button"/>" />
        </p>
    </form>

    <table class="tabela">
        <tr class="tituloTabela">
            <td colspan="4"><fmt:message key="jsp.tools.group-list.tabela"/></td>
        </tr>
        <tr>
            <th><fmt:message key="jsp.tools.group-list.id" /></th>
            <th><fmt:message key="jsp.tools.group-list.name"/></th>
            <th colspan="2"><fmt:message key="jsp.tools.group-list.action"/></th>
        </tr>

<%
    for (int i = 0; i < groups.length; i++)
    {
        if(i % 2 == 0){
%>
            <tr>
                <%
        } else {
        %>
        <tr class="stripe">
            <%
        }
        %>
                <td><%= groups[i].getID() %></td>
                <td><%= groups[i].getName() %></td>
                <td>
<%
	// no edit button for group anonymous
	if (groups[i].getID() > 0 )
	{
%>
                    <form method="post" action="">
                        <input type="hidden" name="group_id" value="<%= groups[i].getID() %>"/>
  		        <input type="submit" class="button" name="submit_edit" value="<fmt:message key="jsp.tools.general.edit"/>" />
                   </form>
<%
	}
%>
                </td>
                <td>
<%
	// no delete button for group Anonymous 0 and Administrator 1 to avoid accidental deletion
	if (groups[i].getID() > 1 )
	{
%>
                    <form method="post" action="">
                        <input type="hidden" name="group_id" value="<%= groups[i].getID() %>"/>
	                <input type="submit" class="buttonRed" name="submit_group_delete" value="<fmt:message key="jsp.tools.general.delete"/>" />
<%
	}
%>
                    </form>
                </td>
            </tr>
<%
    }
%>
    </table>
</dspace:layout>
