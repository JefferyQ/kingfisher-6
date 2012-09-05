<cfhttp url="http://maps.googleapis.com/maps/api/geocode/json?address=DH11HS&sensor=false" result="google" />

<cfset data = DeserializeJSON(google.FileContent)>

<cfset lat = data.results[1].geometry.location.lat>
<cfset lng = data.results[1].geometry.location.lng>

<cfdump var="#lat#">