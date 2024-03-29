<%--
  - itemmap-main.jsp
  -
  - Version: $ $
  -
  - Date: $ $
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


<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%--
  - Display the main page for item mapping (status and controls)
  -
  - Attributes to pass in:
  -
  -   collection        - Collection we're managing
  -   collections       - Map of Collections, keyed by collection_id
  -   collection_counts - Map of Collection IDs to counts
  -   count_native      - how many items are in collection
  -   count_import      - how many items are 'virtual'
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.net.URLEncoder"            %>
<%@ page import="java.util.Iterator"             %>
<%@ page import="java.util.Map"                  %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.Item"        %>
<%@ page import="org.dspace.core.ConfigurationManager" %>

<%
    Collection collection = (Collection) request.getAttribute("collection");
    int count_native = ((Integer) request.getAttribute("count_native")).intValue();
    int count_import = ((Integer) request.getAttribute("count_import")).intValue();
    Map items = (Map) request.getAttribute("items");
    Map collections = (Map) request.getAttribute("collections");
    Map collection_counts = (Map) request.getAttribute("collection_counts");
    Collection[] all_collections = (Collection[]) request.getAttribute("all_collections");
%>

<dspace:layout titlekey="jsp.tools.itemmap-main.title">

    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/itemmap-main.js"></script>
    <%-- Configura as mensagens de alertas de acordo com o idioma atual --%>
    <script type="text/javascript">
        setAlertas("<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.itemmap-main.alert") %>");
    </script>

    <h1><fmt:message key="jsp.tools.itemmap-main.heading"/></h1>

    <div class="painel">
        <p>
            <fmt:message key="jsp.tools.itemmap-main.collection">
                <fmt:param><%=collection.getMetadata("name")%></fmt:param>
            </fmt:message>
        </p>

        <p>
            <fmt:message key="jsp.tools.itemmap-main.info1">
                <fmt:param><%=count_native%></fmt:param>
                <fmt:param><%=count_import%></fmt:param>
            </fmt:message>
        </p>
    </div>

    <%--
        <h3>Quick Add Item:</h3>

    <p>Enter the Handle or internal item ID of the item you want to add:</p>

    <form method="post" action="">
        <input type="hidden" name="action" value="add"/>
        <input type="hidden" name="cid" value="<%=collection.getID()%>"/>
        <center>
            <table class="miscTable">
                <tr class="oddRowEvenCol">
                    <td class="submitFormLabel"><label for="thandle">Handle:</label></td>
                    <td>
                            <input type="text" name="handle" id="thandle" value="<%= ConfigurationManager.getProperty("handle.prefix") %>/" size="12"/>
                            <input type="submit" name="submit" value="Add"/>
                    </td>
                </tr>
                <tr></tr>
                <tr class="oddRowEvenCol">
                    <td class="submitFormLabel"><label for="titem_id">Internal ID:</label></td>
                    <td>
                            <input type="text" name="item_id" id="titem_id" size="12"/>
                            <input type="submit" name="submit" value="Add"/>
                    </td>
                </tr>
            </table>
        </center>
    </form>

    <h3>Import an entire collection</h3>
    <form method="post" action="">
    <input type="hidden" name="cid" value="<%=collection.getID()%>"/>
    <select name="collection2import">
<%  for(int i=0; i<all_collections.length; i++)
    {
        int myID = all_collections[i].getID();

        if( myID != collection.getID() )  // leave out this collection!
        {   %>
        <option value="<%= all_collections[i].getID()%>">
        <%= all_collections[i].getMetadata("name")%>
        </option>
    <%  }
    } %>
    </select>

    <input type="submit" name="action" value="Add Entire Collection!"/>
    </form>
    --%>

    <div class="painel">
        <h2><fmt:message key="jsp.tools.itemmap-main.info4"/></h2>

        <div class="centralizar">
            <p>
                <fmt:message key="jsp.tools.itemmap-main.info5"/>
            </p>
            <form method="post" action="" onsubmit="return validarAutor();">
                <input type="hidden" name="cid" value="<%=collection.getID()%>"/>
                <input type="hidden" name="action" value="Search Authors"/>
                <input type="text" name="namepart" id="namepart" autocomplete="off"
                       onkeyup="ajax_showOptions(this,'starts_with',event,null, null, null,'autor');"/>
                <input type="submit" class="button" value="<fmt:message key="jsp.tools.itemmap-main.search.button"/>" />
                <br/>
            </form>
        </div>
    </div>

    <div class="painel">
        <h2><fmt:message key="jsp.tools.itemmap-main.info6"/></h2>

        <%
            Iterator colKeys = collections.keySet().iterator();

            if (!colKeys.hasNext()) {
        %>
        <p class="centralizar">
            <fmt:message key="jsp.tools.itemmap-main.info8"/>
        </p>
        <%    } else {%>
        <p class="centralizar">
            <fmt:message key="jsp.tools.itemmap-main.info7"/>
        </p>
        <%
            while (colKeys.hasNext()) {
                Collection myCollection = (Collection) collections.get(colKeys.next());
                String myTitle = myCollection.getMetadata("name");
                int cid = collection.getID();
                int myID = myCollection.getID();
                int myCount = ((Integer) collection_counts.get(new Integer(myID))).intValue();

                String myLink = request.getContextPath() + "/tools/itemmap?action=browse";
        %>
        <p class="centralizar">
            <a href="<%=myLink%>&amp;cid=<%=cid%>&amp;t=<%=myID%>"><%=myTitle%> (<%=myCount%>)</a>
        </p>
        <%  }
            }%>
    </div>

    <div class="controles">
        <a href="<%=request.getContextPath() + "/handle/" + collection.getHandle()%>" class="button">
            <fmt:message key="jsp.tools.itemmap-main.return"/>
        </a>
    </div>
</dspace:layout>
