$(document).ready(function() {
    $('.confirmDelete').click(function() {
		var answer = confirm('Are you sure you wish to delete that?');
		
		if (answer)
			return true;
		else 
			return false;	
	});
});