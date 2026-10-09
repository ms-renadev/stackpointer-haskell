// ==========================================
// 1. DATA STRUCTURE DEFINITIONS
// ==========================================
DEFINE TYPE Disk  = { DiskA, DiskB, DiskC }   // DiskA (top), DiskB (mid), DiskC (bottom)
DEFINE TYPE Peg   = { S, A, T }               // Source, Auxiliary, Target
DEFINE TYPE Address = Integer

STRUCTURE StackFrame {
    currentDisk : Disk
    sourcePeg   : Peg
    targetPeg   : Peg
    auxPeg      : Peg
    savedSP     : Address
}

STRUCTURE SimState {
    sp     : Address
    memory : Map of (Address -> StackFrame)
}


// ==========================================
// 2. MAIN SIMULATION ALGORITHM (Pseudocode)
// ==========================================
FUNCTION hanoiSim(disks, src, target, aux, state):

    // STEP 1: BASE CASE - WALANG DISK
    IF disks is EMPTY THEN
        RETURN (empty list of moves, state)
    END IF

    // STEP 2: BASE CASE - DISKA LANG (PINAKAMALIIT SA TUKTOK)
    IF disks == [DiskA] THEN
        // a. Kunin ang kasalukuyang SP
        currentSP = state.sp
        
        // b. Gumawa ng panibagong Stack Frame
        newFrame = CREATE StackFrame(
            currentDisk = DiskA,
            sourcePeg   = src,
            targetPeg   = target,
            auxPeg      = aux,
            savedSP     = currentSP
        )
        
        // c. PUSH sa RAM Memory at ibaba ang SP (SP - 1)
        newMemory = INSERT newFrame AT currentSP IN state.memory
        newState  = CREATE SimState(sp = currentSP - 1, memory = newMemory)
        
        moveMessage = "Move DiskA from " + src + " to " + target
        RETURN ([moveMessage], newState)
    END IF

    // STEP 3: RECURSIVE STEP - MULTIPLE DISKS ([A, B] o [A, B, C])
    currentSP  = state.sp
    topDisks   = ALL_DISKS_EXCEPT_LAST(disks) // hal. [DiskA, DiskB]
    bottomDisk = LAST_DISK(disks)            // hal. DiskC

    // a. Record / Push ang kasalukuyang Call Frame sa RAM
    frame = CREATE StackFrame(
        currentDisk = bottomDisk,
        sourcePeg   = src,
        targetPeg   = target,
        auxPeg      = aux,
        savedSP     = currentSP
    )
    newMemory = INSERT frame AT currentSP IN state.memory
    nextState = CREATE SimState(sp = currentSP - 1, memory = newMemory)

    // b. RECURSION 1: Ilipat ang mga disk sa itaas mula Source (S) -> Aux (A)
    (moves1, stateAfterRec1) = hanoiSim(topDisks, src, aux, target, nextState)

    // c. MAIN MOVE: Ilipat ang pinakababang disk mula Source (S) -> Target (T)
    mainMove = ["Move " + bottomDisk + " from " + src + " to " + target]

    // d. RECURSION 2: Ilipat ang mga disk mula Aux (A) -> Target (T)
    (moves2, stateAfterRec2) = hanoiSim(topDisks, aux, target, src, stateAfterRec1)

    // e. RETURN: Pagsamahin ang mga galaw at ibalik ang updated Memory State
    allMoves = COMBINE(moves1, mainMove, moves2)
    RETURN (allMoves, stateAfterRec2)


// ==========================================
// 3. EXECUTION FLOW
// ==========================================
FUNCTION main():
    initialState = CREATE SimState(sp = 2000, memory = EMPTY_MAP)
    initialDisks = [DiskA, DiskB, DiskC]
    
    // Simulan ang simulation: S -> Target (T), Aux (A)
    (finalMoves, finalState) = hanoiSim(initialDisks, S, T, A, initialState)
    
    PRINT finalMoves
    PRINT finalState.sp
    PRINT finalState.memory