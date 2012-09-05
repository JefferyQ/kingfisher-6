<cfform name="frmAddOffer" method="post" class="cb greyBox overflow" enctype="multipart/form-data">
	<p>
		<cfinput type="datefield" name="date_start"  required="yes" message="Please select a date for the offer to start from" />
	</p>
	<p>
		<cfinput type="datefield" name="date_finish" required="yes" message="Please select a date for the offer to finish on" />
	</p>
	<p>
		<input type="hidden" name="cmd" value="AddOffer" />
		<input type="submit" name="btnSubmit" value="Add Offer" class="fl bigPinkBtn" />
	</p>
</cfform>