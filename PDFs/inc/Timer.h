//
// Author: Valerio Bertone: valerio.bertone@cern.ch
//

#pragma once

#include <chrono>
#include <string>
#include <iostream>

/**
 * @brief The Timer class computes the time elapsed between start
 * and stop.
 */
class Timer
{
 public:
  /**
   * @brief The Timer default constructor.
   */
  Timer() { start(); }

  /**
   * @brief This function starts the timer.
   */
  void start() { startTime = std::chrono::steady_clock::now(); }

  /**
   * @brief This function stops the timer and reports the elapsed
   * time in seconds since the last time the timer was started.
   */
  void stop()
  {
    auto end = std::chrono::steady_clock::now();
    auto diff = end - startTime;
    printf("time elapsed: %5.6f seconds\n", std::chrono::duration <double, std::milli> (diff).count() * 1e-3);
  }

  void stop(std::string message)
  {
    auto end = std::chrono::steady_clock::now();
    auto diff = end - startTime;
    std::cout<<message<<" "<<std::chrono::duration<double, std::milli>(diff).count() * 1e-3<<std::endl;
  }

  double get()
  {
    auto end = std::chrono::steady_clock::now();
    auto diff = end - startTime;
    return std::chrono::duration<double, std::milli>(diff).count() * 1e-3;
  }

 private:
  std::chrono::time_point<std::chrono::steady_clock> startTime;
};
