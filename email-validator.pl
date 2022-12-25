#!/usr/bin/env perl

my $email = Validate::Email->load();

$email->go();

package Validate::Email
{
	
	use feature qw|say|;
	use Term::ANSIColor qw(:constants);
	
	sub load()
	{
		
		my $class = shift;
		my $regex = qr`(?xim)
		
		# regex grammar
		(?(DEFINE)

			# no punctuation
			(?<punct>[[:punct:]])
	
			# valid e-mail characters
			(?<alnum>[[:alnum:]\.+-]+)
		
		)
		
		^
		# e-mail domain ends with letters
		(?=.*\.[[:alpha:]]+$)
		
		# e-mail contains numbers, letters, + , -
		(?=(?&alnum)@(?&alnum))
		
		# No double @ signs
		(?!.*@.*@)
		
		# dosn't end with numbers
		(?!.*?@.*\.\d+$)
		
		# no two periods in email
		(?!.*\.{2,})

		# no starting punctuation
		(?!(?&punct))
		
		# no punctuation near @ sign (left)
		(?!.*(?&punct)@)
		
		# no punctuation near @ sign (right)
		(?!.*@(?&punct))
		
		# rules above modify wildcard
		.*
		
		`;
		
		return bless ({ regex => $regex }, $class);
		
	}
	
	sub go()
	{
		
		local $Term::ANSIColor::AUTORESET = 1;
		my $self = shift;

		while (1)
		{

			print q|enter e-mail to validate: |;
			
			chomp (my $email = <STDIN>);
			
			if ($email =~ m~q(uit)?~i)
			{
				say BLUE "> quitting!";
				exit 0;
			}
			
			if ($email =~ m`$$self{regex}`)
			{
				say GREEN qq|> ${email} is valid!|;
			}
			else
			{
				say RED qq|> ${email} is invalid!|;
			}
			
		}
	
	}

}


__END__
URL: https://regex101.com/r/0fMpfy/1

# SAMPLE DATA: VALID E-MAILS

email@example.web
email@example.com
firstname.lastname@example-ya.com
email@subdomain.example.com
firstname+lastname@example.com
email@123.123.123.com
1234567890@example.com
email@example-one.com
email@example.name
email@example.museum
email@example.co.jp
firstname-lastname@example.com
amazing@website.amazing

# SAMPLE DATA: INVALID E-MAILS

plainaddress
#@%^%#$@#$@#.com
@example.com
Joe Smith <email@example.com>
email.example.com
email@example@example.com
.email@example.com
email.@example.com
email..email@example.com
あいうえお@example.com
email@example.com (Joe Smith)
email@example
email@-example.com
email@111.222.333.44444
email@example..com
Abc..123@example.com