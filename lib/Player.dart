class Player {
  int score;

  Player() : score = 0;

  void increaseScore(int points) {
    score += points;
  }

  void resetScore() {
    score = 0;
  }
}
