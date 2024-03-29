<%--
  - display-item.jsp
  -
  - Version: $Revision: 4646 $
  -
  - Date: $Date: 2009-12-23 06:42:08 +0000 (Wed, 23 Dec 2009) $
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
  - Renders a whole HTML page for displaying item metadata.  Simply includes
  - the relevant item display component in a standard HTML page.
  -
  - Attributes:
  -    display.all - Boolean - if true, display full metadata record
  -    item        - the Item to display
  -    collections - Array of Collections this item appears in.  This must be
  -                  passed in for two reasons: 1) item.getCollections() could
  -                  fail, and we're already committed to JSP display, and
  -                  2) the item might be in the process of being submitted and
  -                  a mapping between the item and collection might not
  -                  appear yet.  If this is omitted, the item display won't
  -                  display any collections.
  -    admin_button - Boolean, show admin 'edit' button
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.handle.HandleManager" %>
<%@ page import="org.dspace.license.CreativeCommons" %>

<%
    // Attributes
    Boolean displayAllBoolean = (Boolean) request.getAttribute("display.all");
    boolean displayAll = (displayAllBoolean != null && displayAllBoolean.booleanValue());
    Boolean suggest = (Boolean)request.getAttribute("suggest.enable");
    boolean suggestLink = (suggest == null ? false : suggest.booleanValue());
    Item item = (Item) request.getAttribute("item");
    Collection[] collections = (Collection[]) request.getAttribute("collections");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

    // get the workspace id if one has been passed
    Integer workspace_id = (Integer) request.getAttribute("workspace_id");

    // get the handle if the item has one yet
    String handle = item.getHandle();

    // CC URL & RDF
    String cc_url = CreativeCommons.getLicenseURL(item);
    String cc_rdf = CreativeCommons.getLicenseRDF(item);

    // Full title needs to be put into a string to use as tag argument
    String title = "";
    if (handle == null) {
		title = "Workspace Item";
    } else {
        DCValue[] titleValue = item.getDC("title", null, Item.ANY);
        if (titleValue.length != 0) {
            title = titleValue[0].value;
        } else {
            title = "Item " + handle;
        }
    }
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout title="<%= title %>">

<link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>
<%--Scripts para a formatação da página.--%>
<script type="text/javascript" src="<%= request.getContextPath() %>/static/js/riufpa/display-item.js"></script>
<style type="text/css">
    .adminFerr input{
        width: auto !important;
    }
</style>

<%
    if (handle != null)
    {
        if (admin_button)  // admin edit button
        {
%>
    <p>
        <table class="adminFerr">
            <tr>
                <td align="center">
                    <h1><fmt:message key="jsp.admintools"/></h1>
                    <form method="post" action="<%= request.getContextPath() %>/mydspace">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE %>" />
                        <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.mydspace.request.export.item"/>" />
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/mydspace">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE %>" />
                        <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.mydspace.request.export.migrateitem"/>" />
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/dspace-admin/metadataexport">
                        <input type="hidden" name="handle" value="<%= item.getHandle() %>" />
                        <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                    </form>
                    <form method="get" action="<%= request.getContextPath() %>/tools/edit-item">
                        <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                        <%--<input type="submit" name="submit" value="Edit...">--%>
                        <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                    </form>
                </td>
            </tr>
        </table>
    </p>
<%
        }
%>

<p align="center" style="font-size: 16px;">
    <strong>
        <fmt:message key="jsp.display-item.identifier"/><br/>
        <code><%= HandleManager.getCanonicalForm(handle) %></code>
    </strong>
</p>
<br clear="all"/>

<%
    }

    String displayStyle = (displayAll ? "full" : "");
%>
<div>
    <dspace:item-preview item="<%= item %>" />
    <dspace:item item="<%= item %>" collections="<%= collections %>" style="<%= displayStyle %>" />
</div>

    <div class="controles">
<%
    String locationLink = request.getContextPath() + "/handle/" + handle;

    if (displayAll) {
        if (workspace_id != null) {
%>
    <form method="post" action="<%= request.getContextPath() %>/view-workspaceitem">
        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue() %>" />
        <input type="submit" name="submit_simple" value="<fmt:message key="jsp.display-item.text1"/>" />
    </form>
<%
       } else {
%>
    <form method="get" action="<%=locationLink %>">
        <input type="hidden" name="mode" value="simple"/>
        <input type="submit" class="button" name="submit_simple" value="<fmt:message key="jsp.display-item.text1"/>" />
    </form>
<%
        }
    } else {
        if (workspace_id != null) {
%>
    <form method="post" action="<%= request.getContextPath() %>/view-workspaceitem">
        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue() %>" />
        <input type="submit" class="button" name="submit_full" value="<fmt:message key="jsp.display-item.text2"/>" />
    </form>
<%
        } else {
%>
    <form method="get" action="<%=locationLink %>">
        <input type="hidden" name="mode" value="full"/>
        <input type="submit" class="button" name="submit_simple" value="<fmt:message key="jsp.display-item.text2"/>" />
    </form>
<%
        } if (suggestLink) {
%>
    <a href="<%= request.getContextPath() %>/suggest?handle=<%= handle %>" target="new_window">
       <fmt:message key="jsp.display-item.suggest"/>
    </a>
<%
        }
    }
%>

    <form method="get" action="<%= request.getContextPath() %>/displaystats">
        <input type="hidden" name="handle" value="<%= handle %>"/>
        <input type="submit" class="button" name="submit_simple" value="<fmt:message key="jsp.display-item.display-statistics"/>" />
    </form>

</div>

<%
    if (workspace_id != null) {
%>
<div align="center">
   <form method="post" action="<%= request.getContextPath() %>/workspace">
        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue() %>"/>
        <input type="submit" class="button" name="submit_open" value="<fmt:message key="jsp.display-item.back_to_workspace"/>"/>
    </form>
</div>
<%
    }
%>


<%-- SFX Link --%>
<%
    if (ConfigurationManager.getProperty("sfx.server.url") != null) {
%>
    <p align="center">
        <a href="<dspace:sfxlink item="<%= item %>"/>" /><img src="<%= request.getContextPath() %>/image/sfx-link.gif" border="0" alt="SFX Query" /></a>
    </p>
<%
    }
%>


<%-- Create Commons Link --%>
<%
    if (cc_url != null) {
%>
    <p class="submitFormHelp">
        <fmt:message key="jsp.display-item.text3"/>
        <a href="<%= cc_url %>" target="_blank">
            <fmt:message key="jsp.display-item.license"/>
        </a><br/>
    <a href="<%= cc_url %>" target="_blank">
        <img src="<%= request.getContextPath() %>/image/cc-somerights.gif" border="0" alt="Creative Commons" />
    </a>
    </p>
    <!--
    <%= cc_rdf %>
    -->
<%
    }
%>


<p class="submitFormHelp"><fmt:message key="jsp.display-item.copyright"/></p>

</dspace:layout>
