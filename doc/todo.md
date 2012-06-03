 * Create sortable table at schools#index
   * One row per school
     * Columns for each year's fit score
 * Import scores for previous years
   * Need a common ID between school and score rows (SCHID from CARES?)
   * Add School#schid
     * Add index to that!
   * Update importit.rb to match the SCHID between School and Score
     * If we can't find school with matching SCHID, create it, then add score
 * Create trend charts for old fit scores
   * Use d3.js?
 * Possibly store more than Score#value and calculate fit_score on the fly
