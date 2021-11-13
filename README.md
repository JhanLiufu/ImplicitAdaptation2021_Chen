# PredictorController_Chen
Mengzhan (John) Liufu code for Predictor-Controller Paradigm and data processing/analysis at Chen Lab, South China Normal University, Guangzhou. Other members on our research team: Jingyue (Charles) Xu from UCSD, Xueqian (Hokin) Deng from JHU, and Chen Yang from SCNU. Our paradigm employs an in-and-out reaching task under mirror reversal perturbation to investigate the Predictor-Controller complex of human sensorimotor control.

---

## Project Description

### Part I: Predictor Experiment
The Predictor Experiment, first part of our Predictor-Controller paradigm, aims to probe into the predictor module of sensorimotor control. Due to the inherent delays in executing motor commands and receiving sensory feedbacks, all decisions and commands are made for the future. Therefore, we believe that at least in motor control it's necessary for any intelligent agent to have the predictor function (forward model), namely, the internal pathway that **transforms issued motor commands (efference copy) into predicted sensory feedback** .

The task involves human subjects sitting in front of an operating space (see illustration below) first reach their arms towards any arbitrary direction with visual feedback blocked by a goggle, then they are required to report the direction they just reached to by verbally instructing the experimenter to place a direction indicator. After the indicator is placed, endpoint error feedback is provided. The Predictor Experiment consists of three blocks; the **Familiarization block**, **No Visual Feedback Block**, and **Mirror Reversal Block** corresponding to ```P_0_FAMI```, ```P_0_NVF``` and ```P_0_TEST``` matlab files respectively. The No Visual Feedback block provides no endpoint error feedback in order to assess the subjects' baseline bias, and in Mirror Reversal Block subjects were required to report the mirror-reversed direction of their reaching direction.

### Part II: Controller Experiment
The Controller Experiment, second part of the paradigm, focuses on the control function (inverse model). The control problem is as fundamental, if not more, as the predictor problem, because our spontaneous and purposeful movements are all produced by a controller that **transforms desired motor outcome into desired motor command**.

The task in this part involves human subjects sitting in exactly the same environment as in the predictor experiment and reaching for visual targets displayed. Endpoint error feedback is provided at the end of each trial, and no online feedback is provided. The Controller Experiment consists of three blocks; the **Familiarization block**, **No Visual Feedback Block**, and **Mirror Reversal Block** corresponding to ```P_0_FAMI```, ```P_0_NVF``` and ```P_0_TEST``` matlab files respectively. The No Visual Feedback block provides no endpoint error feedback in order to assess the subjects' baseline bias, and in Mirror Reversal Block subjects were required to reach towards the mirror-reversed position of the visual target displayed.

---

## Run the Code
1. When running the experiment with psychtoolbox, change directory to the Controller folder since images in there are used. Type in the terminal ```cd Controller```
2. When running the experiment with psychtoolbox, change directory to the Predictor folder since images in there are used. Type in the terminal ```cd Predictor```
