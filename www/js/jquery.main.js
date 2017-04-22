$(function(){
    //original field values
    var field_values = {
            //id        :  value
            'NameOfUnit'  : 'Unit Name',
            'NameOfHeadOfUnit' : 'Name of Head',
			'StartOfReportsingPeriod'		: 'Reportsing period',
			'EndOfReportsingPeriod'		: 'Reportsing period 2',
			
            'CourseTaught'  : ' ',
            'Examinations'  : ' ',
			'StudentSupervised'  : ' ',
			'CompletedStudentReports'  : ' ',
			'CompletedPhDTheses'  : ' ',
			
            'Grants'  : ' ',
			'ResearchProjects' : ' ',
			'ResearchColaborations' : ' ',
			'ConferencePublications' : ' ',
			'JournalPublications' : ' ',
			
			'Patents' : ' ',
			'IPLicensing' : ' ',
			
			'BestPaperAwards' : ' ',
			'Membership' : ' ',
			'Prizes' : ' ',
			
			'IndustryColaborations' : ' ',
			
			'OtherInformation' : ' ',
			
			//admin
			'NameOfUnitAdmin' : ' ',
			'NameOfTheLaboratory' : ' '
    };


    //inputfocus
	
	//General
    $('input#NameOfUnit').inputfocus({ value: field_values['NameOfUnit'] });
	$('input#NameOfHeadOfUnit').inputfocus({ value: field_values['NameOfHeadOfUnit'] });
	
    //Teaching
    $('input#Examinations').inputfocus({ value: field_values['Examinations'] });
    $('input#CourseTaught').inputfocus({ value: field_values['CourseTaught'] });
    $('input#StudentSupervised').inputfocus({ value: field_values['StudentSupervised'] });
	$('input#CompletedStudentReports').inputfocus({ value: field_values['CompletedStudentReports'] });	
	$('input#CompletedPhDTheses').inputfocus({ value: field_values['CompletedPhDTheses'] });
	
	//Research information
	$('input#Grants').inputfocus({ value: field_values['Grants'] });
	$('input#ResearchProjects').inputfocus({ value: field_values['ResearchProjects'] });
	$('input#ResearchColaborations').inputfocus({ value: field_values['ResearchColaborations'] });
	$('input#ConferencePublications').inputfocus({ value: field_values['ConferencePublications'] });
	$('input#JournalPublications').inputfocus({ value: field_values['JournalPublications'] });
	
	//Technology transfer
	$('input#Patents').inputfocus({ value: field_values['Patents'] });
	$('input#IPLicensing').inputfocus({ value: field_values['IPLicensing'] });
	
	//Distinctions
	$('input#BestPaperAwards').inputfocus({ value: field_values['BestPaperAwards'] });
	$('input#Membership').inputfocus({ value: field_values['Membership'] });
	$('input#Prizes').inputfocus({ value: field_values['Prizes'] });
	
	//Outside Activities Information
	$('input#IndustryColaborations').inputfocus({ value: field_values['IndustryColaborations'] });
	
	//OtherInformation information
	$('input#OtherInformation').inputfocus({ value: field_values['OtherInformation'] });
	
	//ADMIN
	$('input#NameOfUnitAdmin').inputfocus({ value: field_values['NameOfUnitAdmin'] });
	$('input#NameOfTheLaboratory').inputfocus({ value: field_values['NameOfTheLaboratory'] });




    //reset progress bar
    $('#progress').css('width','0');
    $('#progress_text').html('0% Complete');

    //first_step
    $('form').submit(function(){ return false; });
    $('#submit_first').click(function(){
        //remove classes
        $('#first_step input').removeClass('error').removeClass('valid');

        //ckeck if inputs aren't empty
        var fields = $('#first_step input[type=text]');
        var error = 0;
        fields.each(function(){
            var value = $(this).val();
            if( value.length<4 || value==field_values[$(this).attr('id')] ) {
                $(this).addClass('error');
                $(this).effect("shake", { times:3 }, 50);
                
                error++;
            } else {
                $(this).addClass('valid');
            }
        });        
        
        if(!error) {
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('15% Complete');
                $('#progress').css('width','58px');
                
                //slide steps
                $('#first_step').slideUp();
                $('#second_step').slideDown();     
                          
        } else return false;
    });
	
	
	
	
	$('#return_first').click(function(){
        
        //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('0% Complete');
                $('#progress').css('width','0px');
                
                //slide steps
			$('#second_step').slideUp(); 
			   $('#first_step').slideDown();
                   
                          
        
    });
	

	//second_step
	
    $('#submit_second').click(function(){
        //remove classes
        $('#second_step input').removeClass('error').removeClass('valid');

        //ckeck if inputs aren't empty
        var fields = $('#second_step input[type=text]');
        var error = 0;
        fields.each(function(){
            var value = $(this).val();
            if( value==field_values[$(this).attr('id')] && $(this).attr('id') != 'CompletedPhDTheses') {
                $(this).addClass('error');
                $(this).effect("shake", { times:3 }, 50);
                
                error++;
            } else {
                $(this).addClass('valid');
            }
        });              
        
        if(!error) {
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('30% Complete');
                $('#progress').css('width','113px');
                
                //slide steps
                $('#second_step').slideUp();
                $('#3_step').slideDown();     
                          
        } else return false;

    });
	
	$('#return_second').click(function(){
        
        //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('15% Complete');
                $('#progress').css('width','58px');
                
                //slide steps
			$('#3_step').slideUp(); 
			   $('#second_step').slideDown();
                   
                          
        
    });
	
	
	$('#submit_3').click(function(){
        //remove classes
        $('#3_step input').removeClass('error').removeClass('valid');

        //ckeck if inputs aren't empty
        var fields = $('#3_step input[type=text]');
        var error = 0;
        fields.each(function(){
            var value = $(this).val();
            if(value==field_values[$(this).attr('id')] && $(this).attr('id') != 'ResearchColaborations' && $(this).attr('id') != 'ConferencePublications' 
			&& $(this).attr('id') != 'JournalPublications') {
                $(this).addClass('error');
                $(this).effect("shake", { times:3 }, 50);
                
                error++;
            } else {
                $(this).addClass('valid');
            }
        });              
        
        if(!error) {
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('44% Complete');
                $('#progress').css('width','163px');
                
                //slide steps
                $('#3_step').slideUp();
                $('#4_step').slideDown();     
                          
        } else return false;

    });
	
	$('#return_3').click(function(){
        
        //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('30% Complete');
                $('#progress').css('width','113px');
                
                //slide steps
			$('#4_step').slideUp(); 
			   $('#3_step').slideDown();
                   
                          
        
    });
	
	
	$('#submit_4').click(function(){
        
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('58% Complete');
                $('#progress').css('width','213px');
                
                //slide steps
                $('#4_step').slideUp();
                $('#5_step').slideDown();     
                          
       

    });
	
	$('#return_4').click(function(){
        
        //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('44% Complete');
                $('#progress').css('width','163px');
                
                //slide steps
			$('#5_step').slideUp(); 
			   $('#4_step').slideDown();
                   
                          
        
    });

	
	$('#submit_5').click(function(){
             
        
        
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('72% Complete');
                $('#progress').css('width','263px');
                
                //slide steps
                $('#5_step').slideUp();
                $('#6_step').slideDown();     
                          
       

    });
	
	$('#return_5').click(function(){
        
        //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('58% Complete');
                $('#progress').css('width','213px');
                
                //slide steps
			$('#6_step').slideUp(); 
			   $('#5_step').slideDown();
                   
                          
        
    });
	
	
	$('#submit_6').click(function(){
        
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('86% Complete');
                $('#progress').css('width','300px');
                
                //slide steps
                $('#6_step').slideUp();
                $('#7_step').slideDown();     
                          
        

    });
	
	$('#return_6').click(function(){
        
        //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('72% Complete');
                $('#progress').css('width','253px');
                
                //slide steps
			$('#7_step').slideUp(); 
			   $('#6_step').slideDown();
                   
                          
        
    });
	
	
	$('#submit_7').click(function(){
        //remove classes
       

        //ckeck if inputs aren't empty
                     
        
        
             
                //upStartOfCompletedStudentReportsingPeriod progress bar
                $('#progress_text').html('100% Complete');
                $('#progress').css('width','339px');
                
                //slide steps
                //send information to server
				$('form').unbind('submit').submit();
			  
                          
        

    });
	
	
	$('#submit_1_admin').click(function(){
		$('form').unbind('submit').submit();
	});
	
	$('#submit_2_admin').click(function(){
		$('form').unbind('submit').submit();
	});
	
	$('#submit_3_admin').click(function(){
		$('form').unbind('submit').submit();
	});
	
	$('#submit_4_admin').click(function(){
		$('form').unbind('submit').submit();
	});
	
	$('#submit_5_admin').click(function(){
		$('form').unbind('submit').submit();
	});
	
	$('#submit_6_admin').click(function(){
		$('form').unbind('submit').submit();
	});

});
