<%--
  - list-metadata-schemas.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2005, Hewlett-Packard Company and Massachusetts
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
  - Display list of DC schemas
  -
  - Attributes:
  -
  -   formats - the DC formats in the system (MetadataValue[])
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.content.MetadataSchema" %>


<%
    MetadataSchema[] schemas =
        (MetadataSchema[]) request.getAttribute("schemas");
%>

<dspace:layout titlekey="jsp.dspace-admin.list-metadata-schemas.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

    <style type="text/css">
        #tabela{
            width: 70%;
            margin-left: auto;
            margin-right: auto;
        }

        #tabela label{
            font-family: Arial, Verdana;
            text-shadow: 2px 2px 2px #ccc;
            float: left;
            font-weight: bold;
            text-align: right;
            width: 95%;
            line-height: 25px;
            font-size: 15px;
        }

    </style>

  <table>
    <tr>
      <td>
        <h1><fmt:message key="jsp.dspace-admin.list-metadata-schemas.title"/></h1>
      </td>
    </tr>
  </table>

<%
String error = (String)request.getAttribute("error");
if (error!=null) {
%>
    <p align="center">
    <font color="red"><%=error%></font>
    </p>
<% } %>


    <table class="miscTable" align="center" width="500">
        <tr>
            <th class="oddRowOddCol"><strong><fmt:message key="jsp.general.id" /></strong></th>
            <th class="oddRowEvenCol"><strong><fmt:message key="jsp.dspace-admin.list-metadata-schemas.namespace"/></strong></th>
            <th class="oddRowOddCol"><strong><fmt:message key="jsp.dspace-admin.list-metadata-schemas.name"/></strong></th>
            <th class="oddRowOddCol">&nbsp;</th>
        </tr>

<%
    String row = "even";
    for (int i = 0; i < schemas.length; i++)
    {
%>
        <tr>
            <td class="<%= row %>RowOddCol"><%= schemas[i].getSchemaID() %></td>
            <td class="<%= row %>RowEvenCol">
                <a href="<%=request.getContextPath()%>/dspace-admin/metadata-field-registry?dc_schema_id=<%= schemas[i].getSchemaID() %>"><%= schemas[i].getNamespace() %></a>
            </td>
            <td class="<%= row %>RowOddCol">
                <%= schemas[i].getName() %>
            </td>
            <td class="<%= row %>RowOddCol">
		<% if ( schemas[i].getSchemaID() != 1 ) { %>
                <form method="post" action="">
                    <input type="hidden" name="dc_schema_id" value="<%= schemas[i].getSchemaID() %>"/>
                    <input type="button" name="submit_update" value="<fmt:message key="jsp.dspace-admin.general.update"/>" onclick="javascript:document.schema.namespace.value='<%= schemas[i].getNamespace() %>';document.schema.short_name.value='<%= schemas[i].getName() %>';document.schema.dc_schema_id.value='<%= schemas[i].getSchemaID() %>';return null;"/>
                    <input type="submit" name="submit_delete" value="<fmt:message key="jsp.dspace-admin.general.delete-w-confirm"/>"/>
                </form>
		    <% } %>
                </td>
            </tr>
<%
        row = (row.equals("odd") ? "even" : "odd");
    }
%>
    </table>

<form method="post" name="schema" action="">
    <input type="hidden" name="dc_schema_id" value=""/>
    <table id="tabela">
        <tr>
            <td colspan="2">
                <p style="text-align: justify">
                    <fmt:message key="jsp.dspace-admin.list-metadata-schemas.instruction"/>
                </p>
            </td>
        </tr>
        <tr>
            <td>
                <label for="namespace"><fmt:message key="jsp.dspace-admin.list-metadata-schemas.namespace"/>:</label>
            </td>
            <td>
                <input type="text" name="namespace" id="namespace" value=""/>
            </td>
        </tr>
        <tr>
            <td>
                <label for="short_name"><fmt:message key="jsp.dspace-admin.list-metadata-schemas.name"/>:</label>
            </td>
            <td><input type="text" name="short_name" id="short_name" value=""/></td>
        </tr>
        <tr>
            <td>
                <p><input class="button" type="submit" name="submit_add" value="<fmt:message key="jsp.dspace-admin.general.save"/>"/></p>
            </td>
        </tr>
    </table>
</form>
</dspace:layout>
