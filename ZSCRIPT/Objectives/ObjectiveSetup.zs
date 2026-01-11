// ============================================================================
// ObjectiveSetup.zs
// Objectives for Doom 2 with standard actors
// Customize these for your own mod
// ============================================================================

enum LevelNum {
    TOTAL, // Not an actual level, used for storing a total value of a variable that all levels share
    HUB,
    JUNGLE,
    CANYON,
    CHECKPT,
    MINES,
    FACTORY,
    SWAMP,
    TEMPLE
};

const TOTAL_LEVELS = 9;

class ObjectiveSetup : EventHandler
{   
    int secretsNeeded[TOTAL_LEVELS];
    int secretsFound[TOTAL_LEVELS];

    int LevelsClearedOfEnemies;

    int killsNeeded[TOTAL_LEVELS];
    int enemiesKilled[TOTAL_LEVELS];
    bool enemiesCleared[TOTAL_LEVELS];
    
    bool objectivesInitialized; 

    override void WorldLoaded(WorldEvent e)
    {
        // Reset objectives on new game 
        if (e.IsSaveGame == false && level.mapname ~== "hubship")
        {
            objectivesInitialized = false;
        }

        if (!objectivesInitialized){
            for (int i = 0; i < TOTAL_LEVELS; i++){
                secretsFound[i] = 0;
                enemiesKilled[i] = 0;
                enemiesCleared[i] = false;
            }
            objectivesInitialized = true;

            secretsNeeded[0] = 33;  // TOTAL
            secretsNeeded[1] = 13;  // HUB
            secretsNeeded[2] = 8;   // JUNGLE
            secretsNeeded[3] = 6;   // CANYON
            secretsNeeded[4] = 0;   // CHECKPT
            secretsNeeded[5] = 6;   // MINES
            secretsNeeded[6] = 0;   // FACTORY
            secretsNeeded[7] = 0;   // SWAMP
            secretsNeeded[8] = 0;   // TEMPLE

            killsNeeded[0] = 142 + 133;  // TOTAL
            killsNeeded[1] = 0;          // HUB
            killsNeeded[2] = 142;        // JUNGLE
            killsNeeded[3] = 0;          // CANYON
            killsNeeded[4] = 0;          // CHECKPT
            killsNeeded[5] = 133;        // MINES
            killsNeeded[6] = 0;          // FACTORY
            killsNeeded[7] = 0;          // SWAMP
            killsNeeded[8] = 0;          // TEMPLE
        }

        // Objectives shown to all levels

        UniversalObjective.Add("Levels Cleared of Enemies", 4, UniversalObjective.TYPE_CUSTOM);
        UniversalObjective.UpdateProgress("Levels Cleared of Enemies", LevelsClearedOfEnemies);

        if (level.mapname ~== "jungle")
        {
            UniversalObjective.Add("Find Jungle Secrets", secretsNeeded[2], UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("Find Jungle Secrets", secretsFound[JUNGLE]);

            UniversalObjective.Add("All Jungle Enemies Killed", killsNeeded[JUNGLE], UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("All Jungle Enemies Killed", enemiesKilled[JUNGLE]);
        }
        else if (level.mapname ~== "mines")
        {
            UniversalObjective.Add("Find Mines Secrets", secretsNeeded[MINES], UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("Find Mines Secrets", secretsFound[MINES]);

            UniversalObjective.Add("All Mines Enemies Killed", killsNeeded[MINES], UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("All Mines Enemies Killed", enemiesKilled[MINES]);
        }
    }

    override void WorldThingDied(WorldEvent e)
    {
        // Jungle Genocide tracker
        if (e.Thing && !(e.Thing is "EnemyBarrel"))
        {
            if (level.mapname ~== "jungle"){
                enemiesKilled[JUNGLE]++;
                UniversalObjective.UpdateProgress("All Jungle Enemies Killed", enemiesKilled[JUNGLE]);
            }
            if (level.mapname ~== "mines"){
                enemiesKilled[MINES]++;
                UniversalObjective.UpdateProgress("All Mines Enemies Killed", enemiesKilled[MINES]);
            }
        }
    }
    
}