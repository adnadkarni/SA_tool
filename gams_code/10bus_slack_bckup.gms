$set matout "'matsol.gdx', model_status,solver_status,Vmag,Vr,Vi,Pg,Qg,Pl,Ql,Bsvc,tap,eMVA_max,Pflow,Qflow,sv,spg,sqg,spl,sbsvc";

Sets
BI, GI(BI), LI(BI), PVI(GI), NGI(BI), SVCI(BI), BrI, LTCI(BI)
;

$GDXIN mat2gms_sets.gdx
$LOAD BI,GI,LI,PVI,SVCI,LTCI
$GDXOUT

Sets
LTCfI(LTCI) /B10/
LTCtI(LTCI) /B4/
LTCf /B10.B10/
LTCt /B4.B4/
LTCft /B10.B4,B4.B10/
;

NGI(BI) = not GI(BI);
Alias(BI,m);
Alias(LTCI,k);

************************************************************************************************************************************
************************************************************************************************************************************
* Importing Parameters
$ontext
Parameter G(BI,m), B(BI,m), Gf(BrI,BI), Gt(BrI,BI), Bf(BrI,BI), Bt(BrI,BI),;
$GDXIN mat2gms_Ybus.gdx
$LOAD G,B,Gf,Bf,Gt,Bt
$GDXOUT
$offtext

Parameter G(BI,m), B(BI,m);
$GDXIN mat2gms_Ybus.gdx
$LOAD G,B
$GDXOUT

Parameter busgenary(BI,GI),busloadary(BI,LI),bussvcary(BI,SVCI),brnchary(BI,BI),Slin_max(BI,BI),wl(LI),busltcary(BI,LTCI);
$GDXIN mat2gms_tables.gdx
$LOAD busgenary,busloadary,bussvcary,brnchary,Slin_max,wl,busltcary
$GDXOUT

Parameter pf(LI),Pgmax(GI),Pgmin(GI),Qgmax(GI),Qgmin(GI),Vmax(BI),Vmin(BI),Plmin(LI),Plmax(LI),Qlmin(LI),Bsvcmax(BI),Bsvcmin(BI),Xs(GI),Xad(GI),Bltc(LTCI,LTCI),Ifdmax(GI),Sgmax(GI);
$GDXIN mat2gms_varlim.gdx
$LOAD pf,Pgmax,Pgmin,Qgmax,Qgmin,Vmax,Vmin,Plmin,Plmax,Qlmin,Bsvcmax,Bsvcmin,Xs,Xad,Bltc,Ifdmax,Sgmax
$GDXOUT

Parameter svmax(BI),svmin(BI),spgmax(GI),spgmin(GI),sqgmax(GI),sqgmin(GI),sbsvcmax(SVCI),sbsvcmin(SVCI),splmax(LI),splmin(LI),sifdmax(GI),sifdmin(GI);
$GDXIN mat2gms_slack.gdx
$LOAD svmax,svmin,spgmax,spgmin,sqgmax,sqgmin,splmax,splmin,sbsvcmax,sbsvcmin,sifdmax,sifdmin
$GDXOUT

scalar pi /3.14159/

************************************************************************************************************************************
************************************************************************************************************************************
* Defining variables

Variables
        Vr(BI)           Bus voltage(real part)
        Vi(BI)           Bus voltage(imaginary part)
        Vmag(BI)         Voltage magnitude at a bus
        Pg(GI)           Real power generation at a bus
        Qg(GI)           Reactive power generation at a bus
        Pl(LI)           Real power load at a bus
        Ql(LI)           Reactive power load at a bus
        tap
        z                Maximum loading in the system
        Bsvc(SVCI)       Shunt susceptance of SVC
        Pflow(BI,BI)     Real power flow on line
        Qflow(BI,m)
        QflowLTC(LTCI)   Reactive power flow on line
        PflowLTC(LTCI)
        QLTC(LTCI)
   
;

free variables sv(BI),spg(GI),sqg(GI),spl(LI),sbsvc(SVCI),sifd(GI);
positive variable Ifd(GI);
************************************************************************************************************************************
************************************************************************************************************************************
* Assigning starting point

*execute_loadpoint 'OPF_trial_p.gdx';
Parameters Vmag_ini(BI),Pg_ini(GI),Qg_ini(GI),Pl_ini(LI),Vr_ini(BI),Vi_ini(BI),Bsvc_ini(SVCI),Ifd_ini(GI);
$GDXIN mat2gms_ini.gdx
$LOAD Vmag_ini,Pg_ini,Qg_ini,Pl_ini,Vr_ini,Vi_ini,Bsvc_ini,Ifd_ini
$GDXOUT

Vmag.l(BI) = Vmag_ini(BI);
Pg.l(GI) = Pg_ini(GI);
Qg.l(GI) = Qg_ini(GI);
Pl.l(LI) = Pl_ini(LI);
Vr.l(BI) = Vr_ini(BI);
Vi.l(BI) = Vi_ini(BI);
Bsvc.l(SVCI) = Bsvc_ini(SVCI);
Ifd.l(GI) = Ifd_ini(GI);

************************************************************************************************************************************

Equations
* Power balance constraints
        obj                     Maximum load the system can handle
        ePbal(BI)               Real power balance at bus k
        eQbal(BI)               Reactive power balance at bus

* Other Equality constraints
        epf_load(LI)            Equation for constant power factor loads
        eVmag(BI)               Voltage magnitude
        ePflow(BI,m)            Real power flow on a line
        eQflow(BI,m)            Reactive power flow on a line
        erefangle               Slack bus angle

* Variable limits
        eV(BI)
        ePg(GI)       
*        eQg(GI)        
        ePl(LI)        
        eBsvc(SVCI)
        eMVA_max(BI,m)
        eIfd(GI)
        
* Generator limits
	eifdmax(GI)
        esmax(GI)

* Tap changer equations
        etap_shunt_from(LTCI)
        etap_shunt_to(LTCI)
        etap_qflow(LTCI)
        etap_pflow(LTCI)
;
************************************************************************************************************************************
************************************************************************************************************************************
* Equation definition

obj..                   z =e=  sum(BI,sqr(sv(BI)))  + sum(GI,sqr(spg(GI))+ sqr(sqg(GI)) + sqr(sifd(GI))) + sum(SVCI,sqr(sbsvc(SVCI))) + sum(LI,sqr(spl(LI))) ;

*obj..                   z =e=  sum(BI,abs(sv(BI)))  + sum(GI,abs(spg(GI))) + sum(GI,abs(sqg(GI))) + sum(SVCI,abs(sbsvc(SVCI))) + sum*(LI,abs(spl(LI))) ;

***********************************************************************************************************************************
* Power balance equations

ePbal(BI)..      sum(GI,busgenary(BI,GI)*Pg(GI)) + sum(LTCI,busltcary(BI,LTCI)*(PflowLTC(LTCI)))- sum(LI,busloadary(BI,LI)*Pl(LI)*(1+0*Vmag(LI)+0*sqr(Vmag(LI))))+
                        sum(m,G(BI,m)*(Vr(BI)*Vr(m)+Vi(BI)*Vi(m)) + B(BI,m)*(-Vr(BI)*Vi(m)+Vi(BI)*Vr(m))) =e= 0;

eQbal(BI)..      sum(GI,busgenary(BI,GI)*Qg(GI)) + sum(SVCI,bussvcary(BI,SVCI)*Bsvc(SVCI))*sqr(Vmag(BI)) + sum(LTCI,busltcary(BI,LTCI)*(QLTC(LTCI) + QflowLTC(LTCI)))
                 - sum(LI,busloadary(BI,LI)*Ql(LI)*(1+0*Vmag(LI)+0*sqr(Vmag(LI))))
                 + sum(m,G(BI,m)*(-Vr(BI)*Vi(m)+Vi(BI)*Vr(m)) + B(BI,m)*(-Vr(BI)*Vr(m)-Vi(BI)*Vi(m))) =e= 0;

***********************************************************************************************************************************
* Operating Variable limits

Vmag.up(BI) = Vmax(BI);

Vmag.lo(BI) = Vmin(BI);

Pg.up(GI) = Pgmax(GI);

Pg.lo(GI) = Pgmin(GI);

*Qg.up(GI) = Qgmax(GI);

*Qg.lo(GI) = Qgmin(GI);

Pl.up(LI) = Plmax(LI);

Pl.lo(LI) = Plmin(LI);

Bsvc.up(SVCI) = Bsvcmax(SVCI);

Bsvc.lo(SVCI) = Bsvcmin(SVCI);

tap.up = 1.05;

tap.lo = 0.95;

Ifd.up(GI) = Ifdmax(GI);


* Slack variable limits

sv.up(BI) = svmax(BI);

sv.lo(BI) = svmin(BI);

spg.up(GI) = spgmax(GI); 

spg.lo(GI) = spgmin(GI);

*sqg.up(GI) = sqgmax(GI);

*sqg.lo(GI) = sqgmin(GI);

spl.up(LI) = splmax(LI); 

spl.lo(LI) = splmin(LI);

sbsvc.up(SVCI) = sbsvcmax(SVCI);

sbsvc.lo(SVCI) = sbsvcmin(SVCI);

sifd.up(GI) = sifdmax(GI);

sifd.lo(GI) = sifdmin(GI);


* Soft constraints

eV(BI)..               Vmag(BI)  =e= Vmag_ini(BI) + sv(BI);

ePg(GI)..              Pg(GI)   =e= Pg_ini(GI) + spg(GI);

*eQg(GI)..             Qg(GI)  =e= Qg_ini(GI) + sqg(GI);

ePl(LI)..              Pl(LI)   =e= Pl_ini(LI) + spl(LI);

eBsvc(SVCI)..          Bsvc(SVCI)  =e= Bsvc_ini(SVCI) + sbsvc(SVCI);

eIfd(GI)..             Ifd(GI) =e= Ifd_ini(GI) + sifd(GI);

eMVA_max(BI,m)$(brnchary(BI,m) eq 1)..          sqrt(sqr(Pflow(BI,m)) + sqr(Qflow(BI,m))) =l= (Slin_max(BI,m));

***********************************************************************************************************************************
* Other equality constraints

epf_load(LI)..          		Ql(LI)*pf(LI) =e= Pl(LI)*sqrt(1-sqr(pf(LI)));

erefangle..             		Vi("B1") =e= 0;

eVmag(BI)..             		sqr(Vmag(BI)) =e= sqr(Vr(BI))+sqr(Vi(BI));

ePflow(BI,m)$(brnchary(BI,m) eq 1)..    Vr(BI)*(-G(BI,m)*(Vr(BI)-Vr(m))+B(BI,m)*(Vi(BI)-Vi(m))) +
                                        Vi(BI)*(-G(BI,m)*(Vi(BI)-Vi(m))-B(BI,m)*(Vr(BI)-Vr(m))) =e= Pflow(BI,m);

eQflow(BI,m)$(brnchary(BI,m) eq 1)..    Vi(BI)*(-G(BI,m)*(Vr(BI)-Vr(m))+B(BI,m)*(Vi(BI)-Vi(m))) -
                                        Vr(BI)*(-G(BI,m)*(Vi(BI)-Vi(m))-B(BI,m)*(Vr(BI)-Vr(m))) =e= Qflow(BI,m);


*eflowf1(BrI)..                          sum(BI,Gf(BrI,BI)*Vr(BI) - Bf(BrI,BI)*Vi(BI)) =e= 
*eflowf2(BrI)..                          sum(BI,Bf(BrI,BI)*Vr(BI) + Gf(BrI,BI)*Vi(BI)) =e= 
***********************************************************************************************************************************

***********************************************************************************************************************************
* Generator current limits/Reactive power output constraints

*eifdmax(GI)..       sqr(Pg(GI))+sqr(Qg(GI)+sqr(Vmag(GI))/Xs(GI)) =e= sqr(Xad(GI)/Xs(GI))*sqr(Vmag(GI))*sqr(Ifd(GI));

*esmax(GI)..        sqr(Pg(GI)) + sqr(Qg(GI)) =l= sqr(Sgmax(GI));
***********************************************************************************************************************************

***********************************************************************************************************************************
* Transformer tap changing

*etap_shunt_from(LTCI)$(LTCf(LTCI,LTCI))..       QLTC(LTCI) =e= sqr(Vmag(LTCI))*sum(k$LTCft(LTCI,k),tap*(tap-1)*Bltc(LTCI,k));
*etap_shunt_to(LTCI)$(LTCt(LTCI,LTCI))..         QLTC(LTCI) =e= sqr(Vmag(LTCI))*sum(k$LTCft(LTCI,k),(1-tap)*Bltc(LTCI,k));

*etap_qflow(LTCI)..                              QflowLTC(LTCI) =e= tap*sum(k,Bltc(LTCI,k)*(-Vr(LTCI)*Vr(k) - Vi(LTCI)*Vi(k)));
*etap_pflow(LTCI)..                              PflowLTC(LTCI) =e= tap*sum(k,Bltc(LTCI,k)*(-Vi(LTCI)*Vr(k) + Vr(LTCI)*Vi(k)));
************************************************************************************************************************************
************************************************************************************************************************************

Model OPF_trial /all/;

option nlp=snopt;
option limrow=15;
OPF_trial.optfile=1;
Solve OPF_trial using NLP minimizing z;

parameters model_status,solver_status;
model_status = OPF_trial.modelstat;
solver_status = OPF_trial.solvestat;


execute_unload %matout%;
***********************************************************************************************************************************


