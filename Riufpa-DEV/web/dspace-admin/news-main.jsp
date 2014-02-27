<%--
  - news-main.jsp
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

<%@ page import="org.dspace.core.Constants" %>


<%
    String news = (String)request.getAttribute("news");

    if (news == null)
    {
        news = "";
    }

%>

<dspace:layout titlekey ="jsp.dspace-admin.news-main.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <h1><fmt:message key="jsp.dspace-admin.news-main.heading"/></h1>

<style type="text/css">
    .noticias{
        width: auto;
        padding: 20px;
        background: #EBF0FD;
        overflow:auto;

        margin-left:auto;
        margin-right:auto;

        /* Border style */
        border: 1px solid #5E78B5;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        border-radius: 5px;
    }
</style>

<table class="noticias">

    <tr>
        <td>
            <fmt:message key="jsp.dspace-admin.news-main.news.top"/>
        </td>
        <td>
            <form action="<%= request.getContextPath() %>/dspace-admin/news-edit" method="post">
                <input type="hidden" name="position" value="<fmt:message key="news-top.html"/>" />
                <input type="submit" class="button" name="submit_edit" value="<fmt:message key="jsp.dspace-admin.general.edit"/>" />
            </form>
        </td>
    </tr>

    <tr>
        <td>
            <fmt:message key="jsp.dspace-admin.news-main.news.sidebar"/>
        </td>
        <td>
            <form action="<%= request.getContextPath() %>/dspace-admin/news-edit" method="post">
                <input type="hidden" class="button" name="position" value="<fmt:message key="news-side.html" />" />
                <input type="submit" class="button" name="submit_edit" value="<fmt:message key="jsp.dspace-admin.general.edit"/>" />
            </form>
        </td>
    </tr>

</table>

</dspace:layout>
