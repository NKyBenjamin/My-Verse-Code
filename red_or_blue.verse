
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/SpatialMath } 

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
red_or_blue := class(creative_device):
    # Assigns a red block and a blue block to two arrays
    @editable var RedTile : creative_prop_asset := DefaultCreativePropAsset
    @editable var BlueTile : creative_prop_asset := DefaultCreativePropAsset
    var BlueTilePlacement : [][]?creative_prop = array{}
    var RedTilePlacement : [][]?creative_prop = array{}
    @editable var NumberOfWantedRedRows : int = 0
    @editable var NumberOfWantedRedColumns : int = 0
    @editable var NumberOfWantedBlueRows : int = 0
    @editable var NumberOfWantedBlueColumns : int = 0
    
    
    # This is the events that happen as soon as the game starts
    OnBegin<override>()<suspends>:void=
        # First, we generate the tiles we want
        GenerateRedTiles()
        GenerateBlueTiles()
        # Then, before we commence with the loop, we make it wat for 1.5 seconds. This is because Verse goes straight down the page, so we need to suspend the code for that long
        Sleep(1.5)
        # Go down to the bottom to see why I made this loop:
        AlternationLoop()
    
        
    # Generating the Blue tiles
    GenerateBlueTiles() : void=
        # In Verse, we cannot simply add elements to an array, we can only set new ones
        set BlueTilePlacement = 
            var BlueRowEnd : int = NumberOfWantedBlueRows - 1
            var BlueColumnEnd : int = NumberOfWantedBlueColumns - 1
            # Making our array only have one row for our blocks, starting at the first position
            for (Row := 0..BlueRowEnd):
                # Inducing how many tiles will be in our column
                for (Column := 0..BlueColumnEnd):
                    # Creating our tiles based on the column iteration
                    CreateBlueTilesForIndex(Row, Column)
    
    # Generating the Red tiles
    GenerateRedTiles() : void=
        # Pretty much the same as the Blue tiles...
        set RedTilePlacement = 
            var RedRowStart : int = NumberOfWantedBlueRows
            var RedRowEnd : int = NumberOfWantedBlueRows + NumberOfWantedRedRows - 1
            var RedColumnEnd : int = NumberOfWantedRedColumns - 1
            # Except since we want them side by side, we have to make our red tiles take up the second row
            for (Row := RedRowStart..RedRowEnd):
                for (Column := 0..RedColumnEnd):
                    CreateRedTilesForIndex(Row, Column)

    
    # Creating our individual tiles (turning our top functions into actual squares we can see)
    CreateRedTilesForIndex(XIdx : int, YIdx : int) : ?creative_prop= # Takes our row and our column and maps them for each tile with our block we designated in line 14
        Spacer := 500.0 #We need space between these blocks, or else they will overlap!
        if (XPos := float[XIdx * Spacer], YPos := float[YIdx * Spacer]): # We must declare our positions as spaces!
            return SpawnProp(RedTile, vector3{X := XPos, Y := YPos, Z := 10.0}, IdentityRotation())(0) # This basically spawns a prop of the red tile we declared at the 3D coordinates we get from the GenerateRedTiles function, along with a rotation style!
        else:
            return false
    
    # We must do the same for the Blue tiles using the same method but with different variables!
    CreateBlueTilesForIndex(XIdx : int, YIdx : int) : ?creative_prop=
        Spacer := 500.0
        if (XPos := float[XIdx * Spacer], YPos := float[YIdx * Spacer]):
            return SpawnProp(BlueTile, vector3{X := XPos, Y := YPos, Z := 10.0}, IdentityRotation())(0)
        else:
            return false

    
    # Created our function to remove red tiles for that brief moment!
    RemoveRedTiles():void=
        # First, we declare our rows to be able to reference every block that is red, which works because we are dealing with two arrays here
        if (NumberOfRedRows : int = RedTilePlacement[0].Length):
            # We do the classic array code for each instance of red
            for (RedTilesRow := 0..RedTilePlacement.Length - 1, Column := 0..NumberOfRedRows):
                # Since we are attempting to call back a PROP, we must use the question mark due to Verse using potential failure as control flow, so the ? takes that into consideration
                if (RedTiles := RedTilePlacement[RedTilesRow][Column]?): # Row, then Column, basically finding the coordinates
                    RedTiles.Dispose() # Disposes of the block
                    Print("Red Tile Removed") # For logging purposes :3
            set RedTilePlacement = array{} # For extra measure of deleting the blocks, in which the tile generation function will simply add them back
            
    # Same as the function above, but for Blue tiles!
    RemoveBlueTiles():void=
        if (NumberOfBlueRows : int = BlueTilePlacement[0].Length):
            for (BlueTilesRow := 0..BlueTilePlacement.Length - 1, Column := 0..NumberOfBlueRows):
                if (BlueTiles := BlueTilePlacement[BlueTilesRow][Column]?):
                    BlueTiles.Dispose()
                    Print("Blue Tile Removed")
            set BlueTilePlacement = array{}
    


    #Creating a loop that makes the shapes alternate in terms of appearance               
    AlternationLoop() <suspends> : void= 
        loop:
            RemoveRedTiles() # Removes the red tiles
            Sleep(0.6) # Waits for a bit
            GenerateRedTiles() # Re-generates the red tiles
            RemoveBlueTiles() #Removes the blue tiles instantly
            Sleep(0.6) # Waits for a bit 
            GenerateBlueTiles() # Re-generates the red tiles again!

    <# Added improvements:
            I am going to add user input based on the number of tiles they want of each tile, and create a symmetrical grid based on inputs!
    #>




    
