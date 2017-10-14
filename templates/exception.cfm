<!---
	The variables scope is populated with the exception received.
	If "extras" were provided, they are merged into the variables scope.
--->
<!DOCTYPE html>
<head>
<style type="text/css">
	body {
		font-family: Helvetica,sans-serif;
	}
	h1 {
		font-size: 13px;
	}
	h2 {
		font-size: 12px;
	}
	th, td {
		font-size: 11px;
		border: 1px solid black;
		vertical-align: top;
		border-spacing: 1px;
	}
	td {
		padding: 2px;
		background-color: #ffcc99;
	}
	tr td:first-child {
		background-color: #ff6600;
	}
	tr.userinfo td {
		padding: 2px;
		background-color: #ccccff;
	}
	tr.userinfo td:first-child {
		background-color: #9999ff;
	}
</style>
</head>
<body>
	<cfoutput>
		<cfif variables.keyExists("app") && variables.app.keyExists("name")>
			<h1>Exception in #variables.app.name#</h1>
		<cfelse>
			<h1>Application Exception</h1>
		</cfif>
		<h2>#dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss")#</h2>
		<table>
			<cfif variables.keyExists("user")>
				<tr class="userinfo">
					<td>Username</td><td>#variables.user.username# (#variables.user.userId#)</td>
				</tr>
			</cfif>
			<tr>
				<td>Message</td>
				<td>#variables.exception.message#</td>
			</tr>
			<tr>
				<td>Type</td><td>#variables.exception.type#</td>
			</tr>
			<tr>
				<td>Detail</td><td>#variables.exception.detail#</td>
			</tr>
			<cfif variables.exception.keyExists("errorcode")>
				<tr>
					<td>Error Code</td>
					<td>#variables.exception.errorcode#</td>
				</tr>
			</cfif>
			<cfif variables.exception.keyExists("tagContext")>
				<tr>
					<td>Tag Context</td>
					<td>
						<cfloop array="#variables.exception.tagContext#" index="element">
							#element.template#: #element.line#<br/>
						</cfloop>
					</td>
				</tr>
			</cfif>
			<cfif variables.exception.keyExists("stackTrace")>
				<tr>
					<td>Stack Trace</td><td>#encodeForHtml(variables.exception.stackTrace)#</td>
				</tr>
			</cfif>
		</table>
	</cfoutput>
</body>
</html>