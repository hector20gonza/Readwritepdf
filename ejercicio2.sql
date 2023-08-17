-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-08-2023 a las 16:18:03
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ejercicio2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `cif` varchar(20) DEFAULT NULL,
  `direccion_fiscal` varchar(255) DEFAULT NULL,
  `cp_fiscal` varchar(10) DEFAULT NULL,
  `localidad_fiscal` varchar(255) DEFAULT NULL,
  `provincia_fiscal` varchar(255) DEFAULT NULL,
  `nombre_administrador` varchar(255) DEFAULT NULL,
  `dni_administrador` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`id`, `nombre`, `cif`, `direccion_fiscal`, `cp_fiscal`, `localidad_fiscal`, `provincia_fiscal`, `nombre_administrador`, `dni_administrador`) VALUES
(1, 'Empresa 1', '12345678A', 'Dirección 1', '12345', 'Localidad 1', 'Provincia 1', 'Admin 1', '11111111A'),
(2, 'Empresa 2', '87654321B', 'Dirección 2', '54321', 'Localidad 2', 'Provincia 2', 'Admin 2', '22222222B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `establecimiento`
--

CREATE TABLE `establecimiento` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `cp` varchar(10) DEFAULT NULL,
  `localidad` varchar(255) DEFAULT NULL,
  `provincia` varchar(255) DEFAULT NULL,
  `persona_contacto` varchar(255) DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `sector_actividad` varchar(255) DEFAULT NULL,
  `id_empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `establecimiento`
--

INSERT INTO `establecimiento` (`id`, `nombre`, `direccion`, `cp`, `localidad`, `provincia`, `persona_contacto`, `telefono_contacto`, `email`, `sector_actividad`, `id_empresa`) VALUES
(1, 'Establecimiento 1', 'Dirección 1', '12345', 'Localidad 1', 'Provincia 1', 'Contacto 1', '111111111', 'correo1@example.com', 'Sector 1', 1),
(2, 'Establecimiento 2', 'Dirección 2', '54321', 'Localidad 2', 'Provincia 2', 'Contacto 2', '222222222', 'correo2@example.com', 'Sector 2', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fondo`
--

CREATE TABLE `fondo` (
  `id` int(11) NOT NULL,
  `valor` decimal(10,0) DEFAULT NULL,
  `aportacion` decimal(10,0) DEFAULT NULL,
  `metodo_reposicion` enum('Loomis','Transferencia','Tarjeta') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `fondo`
--

INSERT INTO `fondo` (`id`, `valor`, `aportacion`, `metodo_reposicion`) VALUES
(1, '1000', '500', 'Loomis'),
(2, '2000', '1000', 'Transferencia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formulario`
--

CREATE TABLE `formulario` (
  `id` int(11) NOT NULL,
  `establecimiento_id` int(11) DEFAULT NULL,
  `terminal_id` int(11) DEFAULT NULL,
  `fondo_id` int(11) DEFAULT NULL,
  `fecha_peticion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `formulario`
--

INSERT INTO `formulario` (`id`, `establecimiento_id`, `terminal_id`, `fondo_id`, `fecha_peticion`) VALUES
(1, 1, 1, 1, '2023-08-01'),
(2, 2, 2, 2, '2023-08-02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `terminal`
--

CREATE TABLE `terminal` (
  `id` int(11) NOT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `comision` decimal(10,0) DEFAULT NULL,
  `retorno` enum('Sí','No') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `terminal`
--

INSERT INTO `terminal` (`id`, `tipo`, `comision`, `retorno`) VALUES
(1, 'Cajero', '3', 'Sí'),
(2, 'Datáfono', '2', 'No');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `establecimiento`
--
ALTER TABLE `establecimiento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_empresa` (`id_empresa`);

--
-- Indices de la tabla `fondo`
--
ALTER TABLE `fondo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `formulario`
--
ALTER TABLE `formulario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `establecimiento_id` (`establecimiento_id`),
  ADD KEY `terminal_id` (`terminal_id`),
  ADD KEY `fondo_id` (`fondo_id`);

--
-- Indices de la tabla `terminal`
--
ALTER TABLE `terminal`
  ADD PRIMARY KEY (`id`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `establecimiento`
--
ALTER TABLE `establecimiento`
  ADD CONSTRAINT `establecimiento_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresa` (`id`);

--
-- Filtros para la tabla `formulario`
--
ALTER TABLE `formulario`
  ADD CONSTRAINT `formulario_ibfk_1` FOREIGN KEY (`establecimiento_id`) REFERENCES `establecimiento` (`id`),
  ADD CONSTRAINT `formulario_ibfk_2` FOREIGN KEY (`terminal_id`) REFERENCES `terminal` (`id`),
  ADD CONSTRAINT `formulario_ibfk_3` FOREIGN KEY (`fondo_id`) REFERENCES `fondo` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
