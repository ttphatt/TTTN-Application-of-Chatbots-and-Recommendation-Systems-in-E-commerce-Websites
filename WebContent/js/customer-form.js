$(document).ready(function(){
		$("#customerForm").validate({
			rules: {
				email:{
					required: true,
					email: true,
				},
				
				firstname:{
					required: true,
				},
				
				lastname:{
					required: true,
				},
				
				// password:{
				// 	required: false,
				// },
				
				phone:{
					required: true,
					number: true,	
				},
				
				// confirmPassword:{
				// 	equalTo: "#password",
				// },
				
				address1:{
					required: true,
				},
				
				address2:{
					required: true,
				},
				
				city:{
					required: true,
				},
				
				state:{
					required: true,
				},
				
				zip:{
					required: true,
				},			
			},
			
			messages: {
				email:{
					required: "Please enter your email",
					email: "Your email is not valid",
				},
				
				firstname:{
					required: "Please enter your first name",
				},
				
				lastname:{
					required: "Please enter your last name",
				},
				//
				// password:{
				// 	required: "Please enter your password",
				// },
				
				phone:{
					number: "Phone must contain only number",	
				},
				
				confirmPassword:{
					equalTo: "The password does not match with each other",
				},
				
				address1:{
					required: "Please enter your first address",
				},
				
				address2:{
					required: "Please enter your second address",
				},
				
				city:{
					required: "Please enter your city",
				},
				
				state:{
					required: "Please enter your state",
				},
				
				zip:{
					required: "Please enter your zip code",
				},	
			}
		});
		
		
		$("#buttonCancel").click(function(){
			history.go(-1);
		});
	});