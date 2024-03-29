<%--
  - authorize_policy_edit.jsp
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
  - policy editor - for new or existing policies
  -
  - Attributes:
  -   policy - a ResourcePolicy to be edited
  -   groups - Group [] of groups to choose from
  -   epeople - EPerson [] of epeople to choose from (unused in first version)
  -   edit_title - title of the page ("Collection 13", etc.
  -   id_name - name of string to put in hidden arg (collection_id, etc.)
  -   id - ID of the object policy relates to (collection.getID(), etc.)
  -   newpolicy - set to some string value if this is a new policy
  - Returns:
  -   save_policy   - user wants to save a policy
  -   cancel_policy - user wants to cancel, and return to policy list
  -   "id_name"     - name/value passed in from id_name/id above
  -   group_id      - set if user selected a group
  -   eperson_id    - set if user selected an eperson
  -   start_date    - not set, unused
  -   end_date      - not set, unused
  -   action_id     - set to whatever user chose
  -   (new policy)  - set to a the string passed in above if policy is a new one
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.authorize.ResourcePolicy" %>
<%@ page import="org.dspace.content.Collection"       %>
<%@ page import="org.dspace.core.Constants"           %>
<%@ page import="org.dspace.eperson.EPerson"          %>
<%@ page import="org.dspace.eperson.Group"            %>


<%
    ResourcePolicy policy = (ResourcePolicy) request.getAttribute("policy");
    Group[] groups = (Group[]) request.getAttribute("groups");
    EPerson[] epeople = (EPerson[]) request.getAttribute("epeople");
    String edit_title = (String) request.getAttribute("edit_title");
    String id_name = (String) request.getAttribute("id_name");
    String id = (String) request.getAttribute("id");
    String newpolicy = (String) request.getAttribute("newpolicy");

    // calculate the resource type and its relevance ID
    // to check what actions to present
    int resourceType = policy.getResourceType();
    int resourceRelevance = 1 << resourceType;

    request.setAttribute("LanguageSwitch", "hide");
%>

<dspace:layout titlekey="jsp.dspace-admin.authorize-policy-edit.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">


    <h1><fmt:message key="jsp.dspace-admin.authorize-policy-edit.heading">
            <fmt:param><%= edit_title%></fmt:param>
        </fmt:message></h1>


    <form action="<%= request.getContextPath()%>/tools/authorize" method="post">

        <style type="text/css">
            .centro{
                margin: 0 auto;
            }
            .controles{
                text-align: center;
            }
            .controles input{
                margin-right: 30px;
            }
        </style>

        <table class="centro" summary="Edit Policy Form">
            <tr>
                <th id="t1"><label for="tgroup_id"><fmt:message key="jsp.dspace-admin.general.group-colon"/></label></th>
                <td headers="t1">
                    <select name="group_id" id="tgroup_id">
                        <%  for (int i = 0; i < groups.length; i++) {%>
                        <option value="<%= groups[i].getID()%>" <%= (groups[i].getID() == policy.getGroupID() ? "selected=\"selected\"" : "")%> >
                            <%= groups[i].getName()%>
                        </option>
                        <%  }%>
                    </select>
                </td>
            </tr>

            <tr>
                <th id="t2">
                    <label for="taction_id"><fmt:message key="jsp.dspace-admin.general.action-colon"/></label>
                </th>
                <td headers="t2">
                    <input type="hidden" name="<%=id_name%>" value="<%=id%>" />
                    <input type="hidden" name="policy_id" value="<%=policy.getID()%>" />
                    <select name="action_id" id="taction_id">
                        <%  for (int i = 0; i < Constants.actionText.length; i++) {
                                // only display if action i is relevant
                                //  to resource type resourceRelevance
                                if ((Constants.actionTypeRelevance[i] & resourceRelevance) > 0) {%>
                        <option value="<%= i%>"
                                <%=(policy.getAction() == i ? "selected=\"selected\"" : "")%>>
                            <%= Constants.actionText[i]%>
                        </option>
                        <%          }
                        }%>
                    </select>
                </td>
            </tr>
        </table>

        <% if (newpolicy != null) {%> <input name="newpolicy" type="hidden" value="<%=newpolicy%>"/> <% }%>

        <div class="controles">
            <input class="button" type="submit" name="submit_save_policy" value="<fmt:message key="jsp.dspace-admin.general.save"/>" />
            <input class="button" type="submit" name="submit_cancel_policy" value="<fmt:message key="jsp.dspace-admin.general.cancel"/>" />
        </div>

    </form>
</dspace:layout>
