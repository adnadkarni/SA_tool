function [ db ] = read_db( db_select )

switch db_select
    case 1
        pth = '/media/aditya/Data/PMU_Data/pgcil_10bus';
        [ db ] = read_pgcil10bus( pth );  
    case 2
        pth = '/media/aditya/Data/PMU_Data/PGCIL_DATA_7days';
        [ db ] = read_pgcil7day( pth, [92,93,104,107], 12 );
    case 3
        pth = '/media/aditya/Data/PMU_Data/PGCIL_5hr';
        pmu_list = [21;50;51;53;54;92;93;95;96;104;107;729;733;804];
        [ db ] = read_pgcil5hr( pth, pmu_list, 19 ); 
    case 4
        pth = '/media/aditya/Data/PMU_Data/Itarsi';
        [ db ] = read_WR( pth );
    case 5
        pth = '/media/aditya/Data/PMU_Data/2017_3_18';
        [ db ] = read_getco( pth ,22 );
    case 6
        pth = '/media/aditya/Data/PMU_Data/wr_fault_data';
        [ db ] = read_wrfault( pth, [15339, 15342], 9 );
    case 7
        load ('/media/aditya/Data/PMU_Data/kundur.mat','db');
%         Add noise or extra gitter
%         for s=1:size(db.Qg,1)
%             db.Qg{s}(:,1) = db.Qg{s}(:,1).*(1+0.01*randn(tstp_num,1));
%         end

    case 8
        load ('/media/aditya/Data/PMU_Data/adani400_data.mat');
        db = adani400;
        db.time = duration(0,0,0:0.04:length(db.P{1})*0.04-0.04)';
        clearvars adani400;
        
    case 9
        pth = '/media/aditya/Data/PMU_Data/GETCO_freq';
        [db] = read_wafms(pth, 'event51.csv');
        
end
end

