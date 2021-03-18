function [C_app] = WK_MODEL(Model,x,f)
 switch Model
     
    case 'Model_A'
       C_alpha=x(1);
       alpha=x(2);
       s= 1i.*f.*2.*pi;
       C_app=C_alpha.*(s.^(alpha-1));
    case 'Model_C'
       Rd=x(1);
       C_alpha=x(2);
       alpha=x(3);
       s= 1i.*f.*2.*pi;
       C_app=((C_alpha.*(s.^(alpha-1)))./((C_alpha*Rd.*s.^(alpha))+1));
     case 'Model_B'
       C_stat=x(1);       
       alpha=x(2);
       s= 1i.*f.*2.*pi;
       C_app=C_stat./(s.^(1-alpha)+1);
     case 'Model_E'
       C1=x(1);
       C2=x(2);
       C_alpha=x(3);       
       alpha=x(4);
       s= 1i.*f.*2.*pi;
       C_app=(1+s.^(alpha-1).*(C1+C2).*C_alpha)./(C1.*(1+s.^alpha.*C2.*C_alpha));
     case 'Model_D'
       Rd=x(1);
       C=x(2);
       C_alpha=C;       
       alpha=x(3);
       s= 1i.*f.*2.*pi;
       C_app=(C.*C_alpha.*s.^(alpha))./(Rd.*C.*C_alpha.*s.^(alpha+1)+C_alpha.*s.^alpha+C.*s);
     case 'Model_G'
       Rd=x(1);
       C_alpha=x(2);
       s= 1i.*f.*2.*pi;
       C_app=(C_alpha./(C_alpha*Rd.*s+1));
     case 'Model_F'
       a1=x(1);
       b1=x(2);
       a2=x(3);
       b2=x(4);
       a3=x(5);
       b3=x(6);
       a4=x(7);
       b4=x(8);
       C_stat=x(9);
       s= 1i.*f.*2.*pi;
       C_app=(C_stat.*(a1.*(s+b1)).*(a2.*(s+b2)).*(a3.*(s+b3)).*(a4.*(s+b4)))./...
           ((b1.*(s+a1)).*(b2.*(s+a2)).*(b3.*(s+a3)).*(b4.*(s+a4)));
     otherwise 
           disp ('error')
 end
end