// ============================================================================
// ObjectiveSetup.zs
// Objectives for Doom 2 with standard actors
// Customize these for your own mod
// ============================================================================
//#define TOTAL_LEVELS 9

//const int TOTAL_LEVELS = 9;

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

// const int SECRETS_NEEDED[TOTAL_LEVELS] = {
//     33,  // TOTAL
//     13, // HUB
//     8,  // JUNGLE
//     6,  // CANYON
//     0,  // CHECKPT
//     6,  // MINES
//     0,  // FACTORY
//     0,  // SWAMP
//     0   // TEMPLE
// };
const TOTAL_LEVELS = 9;

class ObjectiveSetup : EventHandler
{   
    int secretsNeeded[TOTAL_LEVELS];
    int secretsFound[TOTAL_LEVELS];

    int LevelsClearedOfEnemies;

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

            Array<int> secretsNeeded = {
                33,  // TOTAL
                13, // HUB
                8,  // JUNGLE
                6,  // CANYON
                0,  // CHECKPT
                6,  // MINES
                0,  // FACTORY
                0,  // SWAMP
                0   // TEMPLE
            };
        }

        // Objectives shown to all levels

        UniversalObjective.Add("Levels Cleared of Enemies", 4, UniversalObjective.TYPE_CUSTOM);
        UniversalObjective.UpdateProgress("Levels Cleared of Enemies", LevelsClearedOfEnemies);

        if (level.mapname ~== "jungle")
        {
            UniversalObjective.Add("Find Jungle Secrets", secretsNeeded[JUNGLE], UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("Find Jungle Secrets", secretsFound[JUNGLE]);

            UniversalObjective.Add("All Jungle Enemies Killed", 142, UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("All Jungle Enemies Killed", enemiesKilled[JUNGLE]);
        }
        else if (level.mapname ~== "mines")
        {
            UniversalObjective.Add("Find Mines Secrets", secretsNeeded[MINES], UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("Find Mines Secrets", secretsFound[MINES]);

            UniversalObjective.Add("All Mines Enemies Killed", 133, UniversalObjective.TYPE_CUSTOM);
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