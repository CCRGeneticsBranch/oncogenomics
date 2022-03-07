<?php
#php ldap.php username=chouh password=xxx infile=email_list.txt > user_list.txt
parse_str(implode('&', array_slice($argv, 1)), $input);

$username = $input["username"];
$password = $input["password"];
$infile = $input["infile"];

$ldaprdn = $username."@nih.gov";
$attributes = array('givenname', 'sn', 'mail', 'department', 'organization', 'telephonenumber','physicaldeliveryofficename','roomnumber', 'streetaddress','l','st','postalcode'); 
$ldapconn = ldap_connect("ldaps://ldapad.nih.gov") or die("Could not connect to LDAP server.");
         
ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3);
        
if ($ldapconn) {
    $ldapbind = ldap_bind($ldapconn, $ldaprdn, $password);
    if ($ldapbind) {
        print("LDAP bind successful...");
        $content = file_get_contents($infile);
        $lines = explode("\n", $content);
        foreach ($lines as $email) {
            $tokens = explode("@", $email);
            $cn = $tokens[0];
            $filter = "(|(mail=$email)(cn=$cn))";
            $results = ldap_search($ldapconn, "OU=NIH,OU=AD,DC=nih,DC=gov", $filter, $attributes);
            $attrs = ldap_get_entries($ldapconn, $results);
            $gn = "NA";
            $sn = "NA";
            $tel = "NA";
            $inst = "NA";
            if (is_array($attrs) && $attrs["count"] > 0) {
                #var_dump($attrs);
                if (is_array($attrs[0]))
                    if (array_key_exists('givenname', $attrs[0])) {
                        $gn = $attrs[0]['givenname'][0];
                        $sn = $attrs[0]['sn'][0];
                        $tel = $attrs[0]['telephonenumber'][0];
                        $inst = $attrs[0]['physicaldeliveryofficename'][0];
                    }
            }
            print("$email\t$gn\t$sn\t$tel\t$inst\n");

        }

    }
}


?>