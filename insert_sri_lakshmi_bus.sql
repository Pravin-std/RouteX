-- ==============================================================================
-- ROUTEX SQL MIGRATION: ADD SRI LAKSHMI SARASWATHI BUS DATA
-- 
-- This migration safely inserts the new route data using the EXISTING 
-- RouteX architecture (bus_routes and stops tables).
-- 
-- It is idempotent: uses ON CONFLICT DO NOTHING to prevent duplicates.
-- No tables are dropped, altered, or created. 
-- ==============================================================================

-- 1. Insert Stops safely
INSERT INTO public.stops (id, name_en, name_ta, district) VALUES
('salem', 'Salem', 'சேலம்', 'Salem'),
('tharamangalam', 'Tharamangalam', 'தாரமங்கலம்', 'Salem'),
('jalakandapuram', 'Jalakandapuram', 'ஜலகண்டாபுரம்', 'Salem')
ON CONFLICT (id) DO NOTHING;

-- 2. Insert Bus Routes safely (Only the 4 image-derived/inferred trips)
-- Note: duration_minutes is marked as NOT NULL in the existing schema.
-- Since it wasn't provided, it has been mathematically inferred from the 
-- start and end times to satisfy the schema constraints. 
-- These 4 end-to-end routes are "image-derived/inferred", NOT verified.
-- Fares are set to 0 (which the UI now parses as "Fare not available").
INSERT INTO public.bus_routes (
    id, bus_number, bus_name, from_id, to_id, 
    departure, arrival, duration_minutes, price, 
    route_type, status, bus_type, intermediate_stops
) VALUES
-- Trip 1: Salem to Jalakandapuram (image-derived/inferred)
('sls-slm-jkp-01', 'TN 19 A 4060', 'Sri Lakshmi Saraswathi', 'salem', 'jalakandapuram', '05:20', '06:25', 65, 0, 'stops', 'onTime', 'ordinary', '{"tharamangalam"}'),

-- Trip 2: Salem to Jalakandapuram (image-derived/inferred)
('sls-slm-jkp-02', 'TN 19 A 4060', 'Sri Lakshmi Saraswathi', 'salem', 'jalakandapuram', '09:31', '10:42', 71, 0, 'stops', 'onTime', 'ordinary', '{"tharamangalam"}'),

-- Trip 3: Salem to Jalakandapuram (image-derived/inferred)
('sls-slm-jkp-03', 'TN 19 A 4060', 'Sri Lakshmi Saraswathi', 'salem', 'jalakandapuram', '12:00', '13:35', 95, 0, 'stops', 'onTime', 'ordinary', '{"tharamangalam"}'),

-- Trip 4: Salem to Jalakandapuram (image-derived/inferred)
('sls-slm-jkp-04', 'TN 19 A 4060', 'Sri Lakshmi Saraswathi', 'salem', 'jalakandapuram', '19:37', '21:00', 83, 0, 'stops', 'onTime', 'ordinary', '{"tharamangalam"}')

ON CONFLICT (id) DO NOTHING;
