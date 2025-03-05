-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tarea_semana_5
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tarea_semana_5
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tarea_semana_5` DEFAULT CHARACTER SET utf8 ;
USE `tarea_semana_5` ;

-- -----------------------------------------------------
-- Table `tarea_semana_5`.`autores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`autores` (
  `id_autores` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre_autores` VARCHAR(200) NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `biografia` VARCHAR(800) NOT NULL,
  PRIMARY KEY (`id_autores`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarea_semana_5`.`libros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`libros` (
  `isbn` INT UNSIGNED NOT NULL,
  `titulo_libro` VARCHAR(200) NOT NULL,
  `editorial` VARCHAR(200) NOT NULL,
  `fecha_publicacion` DATE NOT NULL,
  `numero_pag` INT NOT NULL,
  PRIMARY KEY (`isbn`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarea_semana_5`.`autores_has_libros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`autores_has_libros` (
  `autores_id_autores` INT UNSIGNED NOT NULL,
  `libros_isbn` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`autores_id_autores`, `libros_isbn`),
  INDEX `fk_autores_has_libros_libros1_idx` (`libros_isbn` ASC) VISIBLE,
  INDEX `fk_autores_has_libros_autores_idx` (`autores_id_autores` ASC) VISIBLE,
  CONSTRAINT `fk_autores_has_libros_autores`
    FOREIGN KEY (`autores_id_autores`)
    REFERENCES `tarea_semana_5`.`autores` (`id_autores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_autores_has_libros_libros1`
    FOREIGN KEY (`libros_isbn`)
    REFERENCES `tarea_semana_5`.`libros` (`isbn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarea_semana_5`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`usuario` (
  `dpi` INT UNSIGNED NOT NULL,
  `nombre_lector` VARCHAR(45) NOT NULL,
  `email` VARCHAR(200) NOT NULL,
  `telefono` INT NULL,
  `autores_has_libros_autores_id_autores` INT UNSIGNED NOT NULL,
  `autores_has_libros_libros_isbn` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`dpi`),
  INDEX `fk_usuario_autores_has_libros1_idx` (`autores_has_libros_autores_id_autores` ASC, `autores_has_libros_libros_isbn` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_autores_has_libros1`
    FOREIGN KEY (`autores_has_libros_autores_id_autores` , `autores_has_libros_libros_isbn`)
    REFERENCES `tarea_semana_5`.`autores_has_libros` (`autores_id_autores` , `libros_isbn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarea_semana_5`.`prestamos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`prestamos` (
  `idprestamos` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fecha_inicio` DATE NOT NULL,
  `fecha_limite` DATE NOT NULL,
  `fecha_entrega` DATE NOT NULL,
  `estado` VARCHAR(200) NOT NULL,
  `usuario_dpi` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idprestamos`),
  INDEX `fk_prestamos_usuario1_idx` (`usuario_dpi` ASC) VISIBLE,
  CONSTRAINT `fk_prestamos_usuario1`
    FOREIGN KEY (`usuario_dpi`)
    REFERENCES `tarea_semana_5`.`usuario` (`dpi`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarea_semana_5`.`inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`inventario` (
  `id_articulo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cantidad_stock` INT NOT NULL,
  `cantidad_prestados` INT NOT NULL,
  `prestamos_idprestamos` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_articulo`),
  INDEX `fk_inventario_prestamos1_idx` (`prestamos_idprestamos` ASC) VISIBLE,
  CONSTRAINT `fk_inventario_prestamos1`
    FOREIGN KEY (`prestamos_idprestamos`)
    REFERENCES `tarea_semana_5`.`prestamos` (`idprestamos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tarea_semana_5`.`historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarea_semana_5`.`historial` (
  `id_historial` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `inventario_id_articulo` INT UNSIGNED NOT NULL,
  `libros_isbn` INT UNSIGNED NOT NULL,
  `autores_has_libros_autores_id_autores` INT UNSIGNED NOT NULL,
  `autores_has_libros_libros_isbn` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_historial`),
  INDEX `fk_historial_inventario1_idx` (`inventario_id_articulo` ASC) VISIBLE,
  INDEX `fk_historial_libros1_idx` (`libros_isbn` ASC) VISIBLE,
  INDEX `fk_historial_autores_has_libros1_idx` (`autores_has_libros_autores_id_autores` ASC, `autores_has_libros_libros_isbn` ASC) VISIBLE,
  CONSTRAINT `fk_historial_inventario1`
    FOREIGN KEY (`inventario_id_articulo`)
    REFERENCES `tarea_semana_5`.`inventario` (`id_articulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historial_libros1`
    FOREIGN KEY (`libros_isbn`)
    REFERENCES `tarea_semana_5`.`libros` (`isbn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historial_autores_has_libros1`
    FOREIGN KEY (`autores_has_libros_autores_id_autores` , `autores_has_libros_libros_isbn`)
    REFERENCES `tarea_semana_5`.`autores_has_libros` (`autores_id_autores` , `libros_isbn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
