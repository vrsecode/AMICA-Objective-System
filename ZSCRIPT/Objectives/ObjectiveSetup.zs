// ============================================================================
// ObjectiveSetup.zs
// Objectives for Doom 2 with standard actors
// Customize these for your own mod
// ============================================================================


class ObjectiveSetup : EventHandler
{   

    int totalSecrets;
    int jungleSecrets;
    int minesSecrets;

    int LevelsClearedOfEnemies;

    int jungleKills;
    bool jungleCleared;
    int minesKills;
    bool minesCleared;

    
    bool objectivesInitialized; 

    override void WorldLoaded(WorldEvent e)
    {
        // Reset objectives on new game 
        if (e.IsSaveGame == false && level.mapname ~== "hubship")
        {
            objectivesInitialized = false;
        }

        if (!objectivesInitialized){
            totalSecrets = 0;
            jungleSecrets = 0;
            minesSecrets = 0;

            LevelsClearedOfEnemies = 0;
            jungleKills = 0;
            jungleCleared = false;
            minesKills = 0;
            minesCleared = false;

            objectivesInitialized = true;
        }

        // Objective shown to all levels
        UniversalObjective.Add("Levels Cleared of Enemies", 4, UniversalObjective.TYPE_CUSTOM);
        UniversalObjective.UpdateProgress("Levels Cleared of Enemies", LevelsClearedOfEnemies);

        if (level.mapname ~== "jungle")
        {
            UniversalObjective.Add("All Jungle Enemies Killed", 142, UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("All Jungle Enemies Killed", jungleKills);
        }
        else if (level.mapname ~== "mines")
        {
            UniversalObjective.Add("All Mines Enemies Killed", 133, UniversalObjective.TYPE_CUSTOM);
            UniversalObjective.UpdateProgress("All Mines Enemies Killed", minesKills);
        }
    }

    override void WorldThingDied(WorldEvent e)
    {
        // Jungle Genocide tracker
        if (e.Thing && !(e.Thing is "EnemyBarrel"))
        {
            if (level.mapname ~== "jungle"){
                jungleKills++;
                UniversalObjective.UpdateProgress("All Jungle Enemies Killed", jungleKills);
            }
            if (level.mapname ~== "mines"){
                minesKills++;
                UniversalObjective.UpdateProgress("All Mines Enemies Killed", minesKills);
            }
        }
    }

    
}