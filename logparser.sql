-- logparser: local time & human readable browser & os
select to_localtime(to_timestamp(date,time)) as when,  
       coalesce(s-computername,computer_name()) as server,  
       extract_filename(LogFilename) as logfile, LogRow as line,   
       coalesce(c-ip,'') as ipaddr, coalesce(replace_chr(cs(User-Agent),'+',' '),'') as useragent,   
       coalesce(cs-uri-stem,'') as path, coalesce(cs-uri-query,'') as query,  
       coalesce(cs(Referer),'') as referrer,   
       case strcnt(cs(User-Agent),'LWP::Simple/') when 1 then strcat('Perl script ',extract_prefix(extract_suffix(cs(User-Agent),0,'LWP::Simple/'),0,'+'))  
       else case strcnt(cs(User-Agent),'PSP+(PlayStation+Portable);+') when 1 then strcat('PlayStation Portable ',extract_prefix(extract_suffix(cs(User-Agent),0,'PSP+(PlayStation+Portable);+'),0,')'))  
       else case strcnt(cs(User-Agent),'WebTV/') when 1 then strcat('WebTV ',extract_prefix(extract_suffix(cs(User-Agent),0,'WebTV/'),0,'+'))  
       else case strcnt(cs(User-Agent),'BlackBerry') when 1 then strcat('BlackBerry ',extract_prefix(extract_suffix(cs(User-Agent),0,'BlackBerry'),0,'+'))  
       else case strcnt(cs(User-Agent),'Danger+hiptop+') when 1 then strcat('Danger hiptop ',extract_prefix(extract_suffix(cs(User-Agent),0,'Danger+hiptop+'),0,';'))  
       else case strcnt(cs(User-Agent),'UP.Browser/') when 1 then strcat('UP.Browser ',extract_prefix(extract_suffix(cs(User-Agent),0,'UP.Browser/'),0,'+'))  
       else case strcnt(cs(User-Agent),'Picsel-ePAGE-Browser/') when 1 then strcat('Picsel ePAGE ',extract_prefix(extract_suffix(cs(User-Agent),0,'Picsel-ePAGE-Browser/'),0,'+'))  
       else  
            strcat(strcat(strcat(strcat(strcat( strcat(strcat(  
            -- browser name  
            case strcnt(cs(User-Agent),'Opera+') when 1 then strcat('Opera ',extract_prefix(extract_suffix(cs(User-Agent),0,'Opera+'),0,'+'))  
            else  case strcnt(cs(User-Agent),'Opera/') when 1 then strcat('Opera ',extract_prefix(extract_suffix(cs(User-Agent),0,'Opera/'),0,'+'))  
            else   case strcnt(cs(User-Agent),'iCab+') when 1 then strcat('iCab ',extract_prefix(extract_suffix(cs(User-Agent),0,'iCab+'),0,'+'))  
            else case strcnt(cs(User-Agent),'iCab/') when 1 then strcat('iCab ',extract_prefix(extract_suffix(cs(User-Agent),0,'iCab/'),0,'+'))  
            else  case strcnt(cs(User-Agent),'Netscape/') when 1 then strcat('Netscape ',extract_prefix(extract_suffix(cs(User-Agent),0,'Netscape/'),0,'+'))  
            else   case strcnt(cs(User-Agent),'Netscape6/') when 1 then strcat('Netscape ',extract_prefix(extract_suffix(cs(User-Agent),0,'Netscape6/'),0,'+'))  
            else case strcnt(cs(User-Agent),'MSIE+') when 1 then strcat('MSIE ',extract_prefix(extract_suffix(cs(User-Agent),0,'MSIE+'),0,';'))  
            else  case strcnt(cs(User-Agent),'Firefox/') when 1 then strcat('Firefox ',extract_prefix(extract_suffix(cs(User-Agent),0,'Firefox/'),0,'+'))  
            else   case strcnt(cs(User-Agent),'Safari/') when 1 then strcat('Safari ',extract_prefix(extract_suffix(cs(User-Agent),0,'Safari/'),0,'+'))  
            else case strcnt(cs(User-Agent),'Flock/') when 1 then strcat('Flock ',extract_prefix(extract_suffix(cs(User-Agent),0,'Flock/'),0,'+'))  
            else  case strcnt(cs(User-Agent),'OmniWeb/v') when 1 then strcat('OmniWeb ',extract_prefix(extract_suffix(cs(User-Agent),0,'OmniWeb/v'),0,'+'))  
            else   case strcnt(cs(User-Agent),'Konqueror/') when 1 then strcat('Konqueror ',extract_prefix(extract_suffix(cs(User-Agent),0,'Konqueror/'),0,'+'))  
            else case strcnt(cs(User-Agent),'K-Meleon/') when 1 then strcat('K-Meleon ',extract_prefix(extract_suffix(cs(User-Agent),0,'K-Meleon/'),0,'+'))  
            else  case strcnt(cs(User-Agent),'Camino/') when 1 then strcat('Camino ',extract_prefix(extract_suffix(cs(User-Agent),0,'Camino/'),0,'+'))  
            else   case strcnt(cs(User-Agent),'Galeon/') when 1 then strcat('Galeon ',extract_prefix(extract_suffix(cs(User-Agent),0,'Galeon/'),0,'+'))  
            else case strcnt(cs(User-Agent),'Epiphany/') when 1 then strcat('Epiphany ',extract_prefix(extract_suffix(cs(User-Agent),0,'Epiphany/'),0,'+'))  
            else  case strcnt(cs(User-Agent),'Firebird/') when 1 then strcat('Firebird ',extract_prefix(extract_suffix(cs(User-Agent),0,'Firebird/'),0,'+'))  
            else   case strcnt(cs(User-Agent),'Phoenix/') when 1 then strcat('Phoenix ',extract_prefix(extract_suffix(cs(User-Agent),0,'Phoenix/'),0,'+'))  
            else case strcnt(cs(User-Agent),'Links+(') when 1 then strcat('Links ',extract_prefix(extract_suffix(cs(User-Agent),0,'Links+('),0,';'))  
            else  case strcnt(cs(User-Agent),'+rv:') when 1 then strcat('Mozilla ',extract_prefix(extract_suffix(cs(User-Agent),0,'+rv:'),0,')'))  
            end end end  end end end  end end end  end end end  end end end  end end end  end end,  
            -- operating system  
            strcat(case strcnt(cs(User-Agent),'Windows+') when 1 then  
                 case strcnt(cs(User-Agent),'Windows+NT+6.0') when 1 then ' Windows Vista'  
                 else case strcnt(cs(User-Agent),'Windows+NT+5.2') when 1 then ' Windows 2003'  
                 else case strcnt(cs(User-Agent),'Windows+NT+5.1') when 1 then ' Windows XP'  
                 else case strcnt(cs(User-Agent),'Windows+NT+5.0') when 1 then ' Windows 2000'  
                 else case strcnt(cs(User-Agent),'Windows+NT+') when 1 then strcat(' Windows ',extract_prefix(extract_suffix(cs(User-Agent),0,'Windows+NT+'),0,';'))  
                 else strcat(' Windows ',extract_prefix(extract_prefix(extract_suffix(cs(User-Agent),0,'Windows+'),0,';'),0,')'))  
                 end end end end end  
            else case strcnt(cs(User-Agent),'Win98') when 1 then ' Windows 98'  
            else case strcnt(cs(User-Agent),'Win95') when 1 then ' Windows 95'  
            else case strcnt(cs(User-Agent),'Win+9x+4.90') when 1 then ' Windows ME'  
            else case strcnt(cs(User-Agent),'WinNT4.0') when 1 then ' Windows NT 4'  
            else case strcnt(cs(User-Agent),'OS+X') when 1 then ' Mac OS X'  
            else case strcnt(cs(User-Agent),'Mac') when 1 then  
                 case strcnt(cs(User-Agent),'PPC') when 1 then ' Mac PPC'  
                 else case strcnt(cs(User-Agent),'PowerPC') when 1 then ' Mac PPC'  
                 else ' Mac'  
                 end end  
            else case strcnt(cs(User-Agent),'Linux') when 1 then ' Linux'  
            else case strcnt(cs(User-Agent),'FreeBSD') when 1 then ' FreeBSD'  
            end end end end end end end end end,  
            case strcnt(cs(User-Agent),'Media+Center+PC+') when 1 then strcat(' Media Center ',extract_prefix(extract_prefix(extract_suffix(cs(User-Agent),0,'Media+Center+PC+'),0,';'),0,')')) end)),  
            -- major ISPs  
            case strcnt(cs(User-Agent),'AOL/') when 1 then strcat(' AOL ',extract_prefix(extract_suffix(cs(User-Agent),0,'AOL/'),0,'+'))  
            else case strcnt(cs(User-Agent),'CS+2000+') when 1 then strcat(' CompuServe 2000 ',extract_prefix(extract_suffix(cs(User-Agent),0,'CS+2000+'),0,'/'))  
            end end),  
            -- spyware  
            case strcnt(cs(User-Agent),'FunWebProducts') when 0 then '' else ' FunWebProducts (spyware)' end),  
            case strcnt(cs(User-Agent),'Hotbar') when 1 then ' Hotbar (spyware)' end),  
            case strcnt(cs(User-Agent),'iebar') when 1 then ' IEBar (spyware)' end),  
            case strcnt(cs(User-Agent),'sureseeker.com') when 1 then ' sureseeker (spyware)' end),  
            case strcnt(cs(User-Agent),'FrankenShteiN') when 1 then ' Win32.Mydoom.W (virus)' end)  
       end end end end end end end as browser  
