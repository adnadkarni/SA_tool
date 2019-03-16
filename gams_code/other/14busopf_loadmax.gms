$set matout "'matsol.gdx', model_status,solver_status,Vmag,Vr,Vi,Pg,Qg,Pl,Ql,Pflow,Qflow";

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

Parameter pf(LI),Pgmax(GI),Pgmin(GI),Qgmax(GI),Qgmin(GI),Vmax(BI),Vmin(BI),Plmin(LI),Plmax(LI),Qlmin(LI),Bsvcmax(BI),Bsvcmin(BI),Bltc(LTCI,LTCI),Sgmax(GI);
$GDXIN mat2gms_varlim.gdx
$LOAD pf,Pgmax,Pgmin,Qgmax,Qgmin,Vmax,Vmin,Plmin,Plmax,Qlmin,Bsvcmax,Bsvcmin,Bltc,Sgmax
$GDXOUT

Parameter svmax(BI),svmin(BI),spgmax(GI),spgmin(GI),sqgmax(GI),sqgmin(GI),sbsvcmax(SVCI),sbsvcmin(SVCI),splmax(LI),splmin(LI);
$GDXIN mat2gms_slack.gdx
$LOAD svmax,svmin,spgmax,spgmin,sqgmax,sqgmin,splmax,splmin,sbsvcmax,sbsvcmin
$GDXOUT

Parameter p1(LI),p2(LI),p3(LI),q1(LI),q2(LI),q3(LI);
$GDXIN mat2gms_zip_para.gdx
$LOAD p1,p2,p3,q1,q2,q3
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
        z                Maximum loading in the system
        Bsvc(SVCI)       Shunt susceptance of SVC
        Pflow(BI,m)
        Qflow(BI,m)
;

Variables sv(BI),spg(GI),sqg(GI),spl(LI),sbsvc(SVCI);
************************************************************************************************************************************
************************************************************************************************************************************
* Assigning starting point

*execute_loadpoint 'OPF_trial_p.gdx';
Parameters Vmag_ini(BI),Pg_ini(GI),Qg_ini(GI),Pl_ini(LI),Vr_ini(BI),Vi_ini(BI),Bsvc_ini(SVCI);
$GDXIN mat2gms_ini.gdx
$LOAD Vmag_ini,Pg_ini,Qg_ini,Pl_ini,Vr_ini,Vi_ini,Bsvc_ini
$GDXOUT

Vmag.l(BI) = Vmag_ini(BI);
Pg.l(GI) = Pg_ini(GI);
Qg.l(GI) = Qg_ini(GI);
Pl.l(LI) = Pl_ini(LI);
Vr.l(BI) = Vr_ini(BI);
Vi.l(BI) = Vi_ini(BI);

************************************************************************************************************************************

Equations
* Power balance constraints
        obj                     Maximum load the system can handle
        ePbal(BI)               Real power balance at bus k
        eQbal(BI)               Reactive power balance at bus

* Other Equality constraints
        epf_load(LI)            Equation for constant power factor loads
        eVmag(BI)               Voltage magnitude
        erefangle               Slack bus angle

* Slack equations
        sl_V(BI)
        sl_Pg(GI)       
        sl_Qg(GI)        
        sl_Pl(LI)        
        
* Generator limits
*        esmax(GI)

* Line flow limits
        ePflow(BI,m)
        eQflow(BI,m)

;
************************************************************************************************************************************
************************************************************************************************************************************
* Equation definition

obj..                   z =e=  100*sum(GI,sqr(sv(GI)))  + 300*sum(GI,sqr(spg(GI)) + 100*sqr(sqg(GI))) + 500*sum(LI,sqr(spl(LI))) ;

***********************************************************************************************************************************
* Power balance equations

ePbal(BI)..      sum(GI,busgenary(BI,GI)*Pg(GI)) - sum(LI,busloadary(BI,LI)*Pl(LI)*(p1(LI)+p2(LI)*Vmag(LI)+p3(LI)*sqr(Vmag(LI))))
                        - sum(m,G(BI,m)*(Vr(BI)*Vr(m)+Vi(BI)*Vi(m)) + B(BI,m)*(-Vr(BI)*Vi(m)+Vi(BI)*Vr(m))) =e= 0;

eQbal(BI)..      sum(GI,busgenary(BI,GI)*Qg(GI)) - sum(LI,busloadary(BI,LI)*Ql(LI)*(q1(LI)+q2(LI)*Vmag(LI)+q3(LI)*sqr(Vmag(LI))))
                 - sum(m,G(BI,m)*(-Vr(BI)*Vi(m)+Vi(BI)*Vr(m)) + B(BI,m)*(-Vr(BI)*Vr(m)-Vi(BI)*Vi(m))) =e= 0;
* + sum(SVCI,bussvcary(BI,SVCI)*Bsvc(SVCI)*sqr(Vmag(SVCI)))
***********************************************************************************************************************************
* Operating Variable limits

Vmag.up(BI) = Vmax(BI);

Vmag.lo(BI) = Vmin(BI);

Pg.up(GI) = Pgmax(GI);

Pg.lo(GI) = Pgmin(GI);

Qg.up(GI) = Qgmax(GI);

Qg.lo(GI) = Qgmin(GI);

Pl.up(LI) = Plmax(LI);

Pl.lo(LI) = Plmin(LI);

***************************************************************************
* Slack variable limits

sv.up(BI) = svmax(BI);

sv.lo(BI) = svmin(BI);

spg.up(GI) = spgmax(GI); 

spg.lo(GI) = spgmin(GI);

sqg.up(GI) = sqgmax(GI);

sqg.lo(GI) = sqgmin(GI);

spl.up(LI) = splmax(LI); 

spl.lo(LI) = splmin(LI);

***************************************************************************
* Soft constraints

sl_V(BI)..               Vmag(BI)  =e= Vmag_ini(BI) + sv(BI);

sl_Pg(GI)..              Pg(GI)   =e= Pg_ini(GI) + spg(GI);

sl_Qg(GI)..              Qg(GI)  =e= Qg_ini(GI) + sqg(GI);

sl_Pl(LI)..              Pl(LI)   =e= Pl_ini(LI) + spl(LI);

***********************************************************************************************************************************
* Other equality constraints

epf_load(LI)..          		Ql(LI)*pf(LI) =e= Pl(LI)*sqrt(1-sqr(pf(LI)));

erefangle..             		Vi("B1") =e= 0;

eVmag(BI)..             		sqr(Vmag(BI)) =e= sqr(Vr(BI))+sqr(Vi(BI));

ePflow(BI,m)$(brnchary(BI,m) eq 1)..    Vr(BI)*(-G(BI,m)*(Vr(BI)-Vr(m))+B(BI,m)*(Vi(BI)-Vi(m))) +
                                        Vi(BI)*(-G(BI,m)*(Vi(BI)-Vi(m))-B(BI,m)*(Vr(BI)-Vr(m))) =e= Pflow(BI,m);

eQflow(BI,m)$(brnchary(BI,m) eq 1)..    Vi(BI)*(-G(BI,m)*(Vr(BI)-Vr(m))+B(BI,m)*(Vi(BI)-Vi(m))) -
                                        Vr(BI)*(-G(BI,m)*(Vi(BI)-Vi(m))-B(BI,m)*(Vr(BI)-Vr(m))) =e= Qflow(BI,m);

***********************************************************************************************************************************
Model OPF_trial /all/;

option nlp=conopt;
option limrow=15;
OPF_trial.optfile=1;
Solve OPF_trial using NLP minimizing z;

parameters model_status,solver_status;
model_status = OPF_trial.modelstat;
solver_status = OPF_trial.solvestat;


execute_unload %matout%;
***********************************************************************************************************************************


