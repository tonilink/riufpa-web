<%--
  - authorize_collection_edit.jsp
  -
  - $Id: authorize-collection-edit.jsp 4309 2009-09-30 19:20:07Z bollini $
  -
  - Version: $Revision: 4309 $
  -
  - Date: $Date: 2009-09-30 19:20:07 +0000 (Wed, 30 Sep 2009) $
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
  - Show policies for a collection, allowing you to modify, delete
  -  or add to them
  -
  - Attributes:
  -  collection - Collection being modified
  -  policies - ResourcePolicy [] of policies for the collection
  - Returns:
  -  submit value collection_addpolicy    to add a policy
  -  submit value collection_editpolicy   to edit policy
  -  submit value collection_deletepolicy to delete policy
  -
  -  policy_id - ID of policy to edit, delete
  -
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<%@ page import="java.util.List"     %>
<%@ page import="java.util.Iterator" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.authorize.ResourcePolicy" %>
<%@ page import="org.dspace.content.Collection"       %>
<%@ page import="org.dspace.core.Constants"           %>
<%@ page import="org.dspace.eperson.EPerson"          %>
<%@ page import="org.dspace.eperson.Group"            %>


<%
    Collection collection = (Collection) request.getAttribute("collection");
    List policies =
            (List) request.getAttribute("policies");
%>

<dspace:layout titlekey="jsp.dspace-admin.authorize-collection-edit.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>

    <h1>
        <fmt:message key="jsp.dspace-admin.authorize-collection-edit.policies">
            <fmt:param><%= collection.getMetadata("name")%></fmt:param>
            <fmt:param>hdl:<%= collection.getHandle()%></fmt:param>
            <fmt:param><%= collection.getID()%></fmt:param>
        </fmt:message>
    </h1>


    <form action="<%= request.getContextPath()%>/tools/authorize" method="post">
        <p align="center">
            <input type="hidden" name="collection_id" value="<%=collection.getID()%>" />
            <input class="button" type="submit" name="submit_collection_add_policy" value="<fmt:message key="jsp.dspace-admin.general.addpolicy"/>" />
        </p>
    </form>

    <table class="tabela" summary="Collection Policy Edit Form">
        <tr class="tituloTabela">
            <td colspan="5">Políticas</td>
        </tr>
        <tr>
            <th><fmt:message key="jsp.general.id"/></th>
            <th><fmt:message key="jsp.dspace-admin.general.action"/></th>
            <th><fmt:message key="jsp.dspace-admin.general.group"/></th>
            <th colspan="2">Ação</th>
        </tr>

        <%
            int paridade = 0;
            Iterator i = policies.iterator();

            while (i.hasNext()) {
                ResourcePolicy rp = (ResourcePolicy) i.next();
                if (paridade % 2 == 0) {
        %>
        <tr>
            <%} else {
            %>
        <tr class="stripe">
            <%    }
            %>
            <td><%= rp.getID()%></td>
            <td><%= rp.getActionText()%></td>
            <td><%= (rp.getGroup() == null ? "..." : rp.getGroup().getName())%></td>

            <td>
                <form action="<%= request.getContextPath()%>/tools/authorize" method="post">
                    <input type="hidden" name="policy_id" value="<%= rp.getID()%>" />
                    <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                    <input class="button" type="submit" name="submit_collection_edit_policy" value="<fmt:message key="jsp.dspace-admin.general.edit"/>" />
                </form>
            </td>
            <td>
                <form action="<%= request.getContextPath()%>/tools/authorize" method="post">
                    <input type="hidden" name="policy_id" value="<%= rp.getID()%>" />
                    <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                    <input class="button" type="submit" name="submit_collection_delete_policy" value="<fmt:message key="jsp.dspace-admin.general.delete"/>" />
                </form>
            </td>

        </tr>

        <%
                paridade++;
            }
        %>

    </table>

</dspace:layout>
