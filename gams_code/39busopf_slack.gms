$set matout "'matsol.gdx', model_status,solver_status,Vmag,Vr,Vi,Pg,Qg,Pl,Ql,Bsvc,eMVA_max,Pflow,sv_max,sv_min,spg_max,spg_min,sqg_max,sqg_min,spl_max,sbsvc_max,sbsvc_min,lamda";

Sets
BI, GI(BI), LI(BI), PVI(GI), NGI(BI), SVCI(BI)
LTC1I /B14.B15/
;

$GDXIN mat2gms_sets.gdx
$LOAD BI,GI,LI,PVI,SVCI
$GDXOUT


NGI(BI) = not GI(BI);
Alias(BI,m);
Alias(BI,n);

************************************************************************************************************************************
************************************************************************************************************************************
* Importing input data

Parameter G(BI,m), B(BI,m);
$GDXIN mat2gms_Ybus.gdx
$LOAD G,B
$GDXOUT

Parameter busgenary(BI,GI),busloadary(BI,LI),bussvcary(BI,SVCI),brnchary(BI,BI),Slin_max(BI,BI),wl(LI);
$GDXIN mat2gms_tables.gdx
$LOAD busgenary,busloadary,bussvcary,brnchary,Slin_max,wl
$GDXOUT

Parameter pf(LI),Pgmax(GI),Pgmin(GI),Qgmax(GI),Qgmin(GI),Vmax(BI),Vmin(BI),Plmin(LI),Plmax(LI),Qlmin(LI),Bsvc_max(BI),Bsvc_min(BI),Xs(GI),Xad(GI),ifd_max(GI),st_max(BI),st_min(BI);
$GDXIN mat2gms_para.gdx
$LOAD pf,Pgmax,Pgmin,Qgmax,Qgmin,Vmax,Vmin,Plmin,Plmax,Qlmin,Bsvc_max,Bsvc_min,Xs,Xad,ifd_max
$GDXOUT

Parameter svmax(BI),svmin(BI),spgmax(GI),spgmin(GI),sqgmax(GI),sqgmin(GI),sbsvcmax(SVCI),splmax(LI),splmin(LI),sbsvcmin(SVCI);
$GDXIN mat2gms_slack.gdx
$LOAD svmax,svmin,spgmax,spgmin,sqgmax,sqgmin,splmax,splmin,sbsvcmax,sbsvcmin
$GDXOUT

scalar pi /3.14159/

************************************************************************************************************************************
************************************************************************************************************************************
* Defining parameters and variables

Variables
        Vr(BI)           Bus voltage(real part)
        Vi(BI)           Bus voltage(imaginary part)
        Vmag(BI)         Voltage magnitude at a bus
        Pg(GI)           Real power generation at a bus
        Qg(GI)           Reactive power generation at a bus
        Pl(LI)           Real power load at a bus
        Ql(LI)           Reactive power load at a bus
        z                Maximum loading in the system
        Ir(GI)           Real part of armature current of generator
        Ii(GI)           Imaginary part of armature current of generator
        Bsvc(SVCI)       Shunt susceptance of SVC
        Pflow(BI,BI)     Real power flow on line
        Qflow(BI,BI)     Reactive power flow on line
        Bt(BI,BI)        With tap susceptance
        t(BI)            Tap ratio
;

positive variables sv_max(BI),sv_min(BI),spg_max(GI),spg_min(GI),sqg_max(GI),sqg_min(GI),spl_max(LI),sbsvc_max(SVCI),sbsvc_min(SVCI),lamda;
lamda.fx=0;
************************************************************************************************************************************
************************************************************************************************************************************
* Assigning starting point

*execute_loadpoint 'OPF_trial_p.gdx';
*$ontext
Parameters Vmag_ini(BI),Pg_ini(GI),Qg_ini(GI),Vr_ini(BI),Vi_ini(BI);
$GDXIN mat2gms_ini.gdx
$LOAD Vmag_ini,Pg_ini,Qg_ini,Vr_ini,Vi_ini
$GDXOUT

Vmag.l(BI) = Vmag_ini(BI);
Pg.l(GI) = Pg_ini(GI);
Qg.l(GI) = Qg_ini(GI);
Pl.l(LI) = Plmax(LI);
Vr.l(BI) = Vr_ini(BI);
Vi.l(BI) = Vi_ini(BI);
*$offtext

************************************************************************************************************************************
************************************************************************************************************************************
* Slack variable bounds
sv_max.up(BI) = svmax(BI);
sv_min.up(BI) = svmin(BI);
spg_max.up(GI) = spgmax(GI);
spg_min.up(GI) = spgmin(GI);
sqg_max.up(GI) = sqgmax(GI);
sqg_min.up(GI) = sqgmin(GI);
sbsvc_max.up(SVCI) = sbsvcmax(SVCI);
sbsvc_min.up(SVCI) = sbsvcmin(SVCI);

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
        eMVA_max(BI,m)
        eVmax(BI)
        eVmin(BI)
        ePgmax(GI)
        ePgmin(GI)
        eQgmax(GI)
        eQgmin(GI)
        ePlmin(LI)
        ePlmax(LI)
        ePl(LI)
        eBsvcmax(SVCI)
        eBsvcmin(SVCI)

* Generator limits
*    ecapab(GI)
*    esmax(GI)

* Tap changer equations
etap1(BI,m)
etap2(BI,m)
;
************************************************************************************************************************************
************************************************************************************************************************************
* Equation definition

*obj..                   z =e= sum(LI,wl(LI)*Pl(LI)) - sum(BI,sv_max(BI)) - sum(BI,sv_min(BI)) - sum(GI,spg_max(GI)) - sum(GI,spg_min*(GI)) - sum(GI,sqg_max(GI)) - sum(GI,sqg_min(GI)) - sum(SVCI,sbsvc_max(SVCI)) - sum(SVCI,sbsvc_min(SVCI));

obj..                   z =e= 1000*lamda - sum(BI,sv_max(BI)) - sum(BI,sv_min(BI)) - sum(GI,spg_max(GI)) - sum(GI,spg_min(GI)) - sum(GI,sqg_max(GI)) - sum(GI,sqg_min(GI)) - sum(SVCI,sbsvc_max(SVCI)) - sum(SVCI,sbsvc_min(SVCI));


***********************************************************************************************************************************
* Power balance equations

ePbal(BI)..      sum(GI,busgenary(BI,GI)*Pg(GI)) - sum(LI,busloadary(BI,LI)*Pl(LI)*(1+0*Vmag(LI)+0*sqr(Vmag(LI))))-
                        (Vr(BI)*sum(m,G(BI,m)*Vr(m)-Bt(BI,m)*Vi(m)) + Vi(BI)*sum(m,G(BI,m)*Vi(m)+Bt(BI,m)*Vr(m))) =e= 0.0;


eQbal(BI)..      sum(GI,busgenary(BI,GI)*Qg(GI)) + sum(SVCI,bussvcary(BI,SVCI)*Bsvc(SVCI))*sqr(Vmag(BI)) - sum(LI,busloadary(BI,LI)*Ql(LI)*(1+0*Vmag(LI)+0*sqr(Vmag
(LI))))
                 - (-Vr(BI)*sum(m,G(BI,m)*Vi(m)+Bt(BI,m)*Vr(m)) + Vi(BI)*sum(m,G(BI,m)*Vr(m)-Bt(BI,m)*Vi(m))) =e= 0.00;

***********************************************************************************************************************************
* Variable limits

eVmax(BI)..         Vmag(BI) - sv_max(BI) =l= Vmax(BI);

eVmin(BI)..         Vmag(BI) + sv_min(BI) =g= Vmin(BI);

ePgmax(GI)..        Pg(GI) - spg_max(GI)  =l= Pgmax(GI);

ePgmin(GI)..        Pg(GI) + spg_min(GI)  =g= Pgmin(GI);

eQgmax(GI)..        Qg(GI) - sqg_max(GI)  =l= Qgmax(GI);

eQgmin(GI)..        Qg(GI) + sqg_min(GI)  =g= Qgmin(GI);

ePlmax(LI)..        Pl(LI)                =l= Plmax(LI);

ePlmin(LI)..        Pl(LI)                =g= Plmin(LI);

ePl(LI)..           Pl(LI)                =e= (1+lamda)*Plmin(LI);

eBsvcmax(SVCI)..    Bsvc(SVCI) - sbsvc_max(SVCI) =l= Bsvc_max(SVCI);

eBsvcmin(SVCI)..    Bsvc(SVCI) + sbsvc_min(SVCI) =g= Bsvc_min(SVCI);

etmax(BI)..          t(BI) + st_max(BI) =l= t_max(BI);

etmin(BI)..          t(BI) - st_min(BI) =g= t_min(BI);

***********************************************************************************************************************************
* Other equality constraints

epf_load(LI)..          Ql(LI)*pf(LI) =e= Pl(LI)*sqrt(1-sqr(pf(LI)));

erefangle..             Vi("B1") =e= 0;

eVmag(BI)..             sqr(Vmag(BI)) =e= sqr(Vr(BI))+sqr(Vi(BI));
***********************************************************************************************************************************

***********************************************************************************************************************************
* Line flow constraint

ePflow(BI,m)$(brnchary(BI,m) eq 1)..            Vr(BI)*(-G(BI,m)*(Vr(BI)-Vr(m))+Bt(BI,m)*(Vi(BI)-Vi(m))) +
                                                  Vi(BI)*(-G(BI,m)*(Vi(BI)-Vi(m))-Bt(BI,m)*(Vr(BI)-Vr(m))) =e= Pflow(BI,m);

eQflow(BI,m)$(brnchary(BI,m) eq 1)..            Vi(BI)*(-G(BI,m)*(Vr(BI)-Vr(m))+Bt(BI,m)*(Vi(BI)-Vi(m))) -
                                                  Vr(BI)*(-G(BI,m)*(Vi(BI)-Vi(m))-Bt(BI,m)*(Vr(BI)-Vr(m))) =e= Qflow(BI,m);

eMVA_max(BI,m)$(brnchary(BI,m) eq 1)..          sqrt(sqr(Pflow(BI,m)) + sqr(Qflow(BI,m))) =l= (Slin_max(BI,m));
***********************************************************************************************************************************

***********************************************************************************************************************************
* Generator current limits/Reactive power output constraints

*ecapab(GI)..       sqr(Pg(GI))+sqr(Qg(GI)+sVmag(GI)/Xs(GI)) =l= sqr(Xad(GI)/Xs(GI))*sVmag(GI)*sqr(ifd_max(GI));
*esmax(GI)..        sqr(Pg(GI)) + sqr(Qg(GI)) =l= sqr(Smax(GI));
***********************************************************************************************************************************

***********************************************************************************************************************************
* Transformer tap changing
$ontext
etap1 equ is for the from branch. etap2 is for the from-to branch.
$offtext
etap1(BI,m)$(brnchary(BI,m) eq 2)..                Bt(BI,m) =e= B(BI,m) + sum(n$(LTC1I(BI,n)),(1-sqr(t(BI)))*B(BI,n));

etap2(BI,m)$(brnchary(BI,m) eq 1)..                Bt(BI,m) =e= B(BI,m) - (1-t(BI))*B(BI,m);

sum(BrI$BBr(BI,BrI),(1-t(BrI))*B(BrI))
************************************************************************************************************************************
************************************************************************************************************************************

Model OPF_trial /all/;

option nlp=snopt;
OPF_trial.optfile=1;
Solve OPF_trial using NLP maximizing z;

parameters model_status,solver_status;
model_status = OPF_trial.modelstat;
solver_status = OPF_trial.solvestat;


execute_unload %matout%;
***********************************************************************************************************************************


