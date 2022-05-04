SELECT * FROM nflrbs.arush;
SELECT * FROM nflrbs.arec;

-- Table 1 Totals
SELECT rush.active_rbs, rush.total_rush, rec.total_rec, (rush.total_rush + rec.total_rec) as total_yds,
(rush.total_tds + rec.total_rectds) as total_tds
FROM nflrbs.arush rush JOIN nflrbs.arec rec
on rush.active_rbs = rec.active_rbs;

SELECT push.past_rbs, push.ptotal_rush, pec.ptotal_rec, (push.ptotal_rush + pec.ptotal_rec) as total_yds, 
(push.ptotal_tds + pec.total_rectds) as total_tds
FROM nflrbs.prush push JOIN nflrbs.prec pec
on push.past_rbs = pec.past_rbs;

-- Table 2 AVGs (Averaging Chubb and Taylor separately due to insufficient seasons played)
SELECT active_rbs, (total_rush/5) as avgrush_season, (total_tds/5) as avgrush_tds FROM nflrbs.arush;
SELECT active_rbs, (total_rec/5) as avgrec_season, (total_rectds/5) as avgrec_tds FROM nflrbs.arec;

SELECT rush.active_rbs, (rush.total_rush/5) as avgrush_season, (rec.total_rec/5) as avgrec_season, 
(rush.total_tds/5) as avgrush_tds, (rec.total_rectds/5) as avgrec_tds 
FROM nflrbs.arush rush JOIN nflrbs.arec rec
on rush.active_rbs = rec.active_rbs;

SELECT push.past_rbs, (push.ptotal_rush/5) as avgrush_season, (pec.ptotal_rec/5) as avgrec_season, 
(push.ptotal_tds/5) as pavgrush_tds, (pec.total_rectds/5) as pavgrec_tds 
FROM nflrbs.prush push JOIN nflrbs.prec pec
on push.past_rbs = pec.past_rbs;

-- Table 3 Improvements season by season
SELECT active_rbs, s1_rush, (s2_rush - s1_rush) as s2_improvement, (s3_rush - s2_rush) as s3_improvement,
(s4_rush - s3_rush) as s4_improvement, (s5_rush - s4_rush) as s5_imrpovement
FROM nflrbs.arush; -- rush yards improvement

SELECT active_rbs, s1_rush, (s2_rush - s1_rush) as s2_improvyds, ((s2_rush - s1_rush)/s1_rush)*100 as s2_percentimrpov, 
(s3_rush - s2_rush) as s3_improvyds, ((s3_rush - s2_rush)/s2_rush)*100 as s3_percentimprov,
(s4_rush - s3_rush) as s4_improvyds, ((s4_rush - s3_rush)/s3_rush)*100 as s4_percentimprov,
(s5_rush - s4_rush) as s5_improvyds, ((s5_rush - s4_rush)/s4_rush)*100 as s5_percentimprov
FROM nflrbs.arush; -- Improv rush percentages active

SELECT active_rbs, s1_rec, (s2_rec - s1_rec) as s2_improvyds, ((s2_rec - s1_rec)/s1_rec)*100 as s2_percentimrpov, 
(s3_rec - s2_rec) as s3_improvyds, ((s3_rec - s2_rec)/s2_rec)*100 as s3_percentimprov,
(s4_rec - s3_rec) as s4_improvyds, ((s4_rec - s3_rec)/s3_rec)*100 as s4_percentimprov,
(s5_rec - s4_rec) as s5_improvyds, ((s5_rec - s4_rec)/s4_rec)*100 as s5_percentimprov
FROM nflrbs.arec; -- Reception improvements active

SELECT past_rbs, ps1_rush, (ps2_rush - ps1_rush) as s2_improvyds, ((ps2_rush - ps1_rush)/ps1_rush)*100 as s2_percentimrpov, 
(ps3_rush - ps2_rush) as s3_improvyds, ((ps3_rush - ps2_rush)/ps2_rush)*100 as s3_percentimprov,
(ps4_rush - ps3_rush) as s4_improvyds, ((ps4_rush - ps3_rush)/ps3_rush)*100 as s4_percentimprov,
(ps5_rush - ps4_rush) as s5_improvyds, ((ps5_rush - ps4_rush)/ps4_rush)*100 as s5_percentimprov
FROM nflrbs.prush;

SELECT past_rbs, ps1_rec, (ps2_rec - ps1_rec) as s2_improvyds, ((ps2_rec - ps1_rec)/ps1_rec)*100 as s2_percentimrpov, 
(ps3_rec - ps2_rec) as s3_improvyds, ((ps3_rec - ps2_rec)/ps2_rec)*100 as s3_percentimprov,
(ps4_rec - ps3_rec) as s4_improvyds, ((ps4_rec - ps3_rec)/ps3_rec)*100 as s4_percentimprov,
(ps5_rec - ps4_rec) as s5_improvyds, ((ps5_rec - ps4_rec)/ps4_rec)*100 as s5_percentimprov
FROM nflrbs.prec;

-- Table 4 Standard Deviation (looking at outlier RBS exclude Taylor & Chubb)
-- (mean rush yds = 5905)(mean rec yds = 1579)(total yds mean = 7485 yds)(total td mean = 55)

SELECT active_rbs, total_rush, 
((total_rush - 5905)*(total_rush - 5905)) as arush_xi
FROM nflrbs.arush;

SELECT past_rbs, ptotal_rush, 
((ptotal_rush - 5905)*(ptotal_rush - 5905)) as prush_xi
FROM nflrbs.prush;
-- (rush sum (xi-mean)^2 = 26,208,966)

SELECT active_rbs, total_rec, 
((total_rec - 1579)*(total_rec - 1579)) as arec_xi
FROM nflrbs.arec;

SELECT past_rbs, ptotal_rec, 
((ptotal_rec - 1579)*(ptotal_rec - 1579)) as prec_xi
FROM nflrbs.prec;
-- (rec sum (xi-mean)^2 = 7,767,578)

-- create CTE to look at total yards calculations
WITH Atotal (Active_Rbs, Total_Rush, Total_Rec, Atotal_yds)
as (
SELECT rush.active_rbs, rush.total_rush, rec.total_rec, (rush.total_rush + rec.total_rec) as atotal_yds
FROM nflrbs.arush rush JOIN nflrbs.arec rec
on rush.active_rbs = rec.active_rbs
)

SELECT active_rbs, atotal_yds, 
((atotal_yds - 7485)*(atotal_yds - 7485)) as atotal_xi
FROM Atotal;
-- Active Total yds sum (xi-mean)^2 = 9,310,647

WITH Ptotal (Past_Rbs, Ptotal_Rush, Ptotal_Rec, Ptotal_yds)
as (
SELECT rush.past_rbs, rush.ptotal_rush, rec.ptotal_rec, (rush.ptotal_rush + rec.ptotal_rec) as ptotal_yds
FROM nflrbs.prush rush JOIN nflrbs.prec rec
on rush.past_rbs = rec.past_rbs
)

SELECT past_rbs, ptotal_yds, 
((ptotal_yds - 7485)*(ptotal_yds - 7485)) as ptotal_xi
FROM Ptotal;
-- Past Total yds sum (xi-mean)^2 = 7,542,613
-- Total yds sum (xi-mean)^2 = 16,853,260

-- Standard Deviation calculations to figure out if any Outliers
-- Rush
SELECT active_rbs, (sqrt(26208966/14)) as arun_std
FROM nflrbs.arush;
-- Standard Deviation for Rush Yds is 1368.24, SD * 3 = 4,104.72 (boundaries for outliers)
-- with mean yds at 5905, 10,009yds would be an outlier, which no rb is over 

SELECT active_rbs, total_rush, ((total_rush - 5905) / 1368.24) as deviation
FROM nflrbs.arush;

SELECT past_rbs, ptotal_rush, ((ptotal_rush - 5905) / 1368.24) as pdeviation
FROM nflrbs.prush;
-- Excluding Taylor, Chubb, Dickerson was the only RB over 1 deviation
-- Another examination shows only Elliot was able to put up enough rush yds in first 5 seasons to compete with the legends

-- Rec
SELECT active_rbs, (sqrt(7767578/14)) as arec_std
FROM nflrbs.arec;
-- Standard Deviation for Rec yds = 744.87   Rec SD * 3 = 2234.61
-- Rec yds mean is 1579, so 3813.61 yds is the outlier threshold

SELECT active_rbs, total_rec, ((total_rec - 1579) / 744.87) as deviation
FROM nflrbs.arec;

SELECT past_rbs, ptotal_rec, ((ptotal_rec - 1579) / 744.87) as deviation
FROM nflrbs.prec;
-- No Outliers, However Kamara was able to outperform all Rbs and was the only one to make it 2 deviations from the mean data

