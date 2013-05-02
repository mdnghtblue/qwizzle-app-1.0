--
-- Database: `qwizzlea_main`
--
CREATE DATABASE `qwizzlea_main` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `qwizzlea_main`;

-- --------------------------------------------------------

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
CREATE TABLE IF NOT EXISTS `answers` (
  `a_id` int(12) NOT NULL AUTO_INCREMENT,
  `answer` text NOT NULL,
  `q_id` int(12) NOT NULL,
  `answer_id` int(12) NOT NULL,
  PRIMARY KEY (`a_id`),
  KEY `fk_answerId` (`answer_id`),
  KEY `fk_questionId` (`q_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;


-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
CREATE TABLE IF NOT EXISTS `questions` (
  `q_id` int(12) NOT NULL AUTO_INCREMENT,
  `question` text NOT NULL,
  `qwizzle_id` int(12) NOT NULL,
  PRIMARY KEY (`q_id`),
  KEY `fk_qwizzleId` (`qwizzle_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;


-- --------------------------------------------------------

--
-- Table structure for table `qwizzle_answers`
--

DROP TABLE IF EXISTS `qwizzle_answers`;
CREATE TABLE IF NOT EXISTS `qwizzle_answers` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `qwizzle_id` int(12) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_userId` (`user_id`),
  KEY `fk_qwizzleId` (`qwizzle_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;


-- --------------------------------------------------------

--
-- Table structure for table `qwizzles`
--

DROP TABLE IF EXISTS `qwizzles`;
CREATE TABLE IF NOT EXISTS `qwizzles` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `creator` int(12) NOT NULL,
  `title` varchar(80) NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_creatorId` (`creator`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;


-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
CREATE TABLE IF NOT EXISTS `requests` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `user_id` int(12) NOT NULL,
  `sender_id` int(12) NOT NULL,
  `qwizzle_id` int(12) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_userId` (`user_id`),
  KEY `fk_senderId` (`sender_id`),
  KEY `fk_qwizzleId` (`qwizzle_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `email` varchar(60) NOT NULL,
  `password` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
