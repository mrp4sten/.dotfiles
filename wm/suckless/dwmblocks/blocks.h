static const Block blocks[] = {
    //   Icon    Command                          Update Interval     Update
    //   Signal
    // {"  ", "checkupdates | wc -l", 1, 0},
    {"󰌌  ", "xkblayout-state print '%s'", 2, 0},
    {"", "brightness", 1, 0},
    {"", "volume", 1, 0},
    {"", "battery", 60, 0},
    {"", "date '+ %d/%m/%Y   %H:%M%p'", 1, 0},
};

// Sets delimeter between status commands. NULL character ('\0') means no
// delimeter.
static char delim[] = "  ";
static unsigned int delimLen = 5;
