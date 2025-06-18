class Nave {
  var velocidad
  var direccion
  var property combustible
  
  method initialize() {
    if (!self.velocidad().between(0, 100000)) self.error(
        "La velocidad debe estar entre 0 y 100.000kms/seg"
      )
    if (!self.direccion().between(-10, 10)) self.error(
        "La direccion debe estar entre -10 y 10"
      )
  }
  
  method direccion() = direccion
  
  method velocidad() = velocidad
  
  method acelerar(cuanto) {
    velocidad = (velocidad + cuanto).min(100000)
  }
  
  method desacelerar(cuanto) {
    velocidad = (velocidad - cuanto).max(0)
  }
  
  method irHaciaElSol() {
    direccion = 10
  }
  
  method escaparDelSol() {
    direccion = -10
  }
  
  method ponerseParaleloAlSol() {
    direccion = 0
  }
  
  method acercarseUnPocoAlSol() {
    direccion = (direccion + 1).min(10)
  }
  
  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).max(-10)
  }
  
  method prepararViaje() {
    self.combustible(30000)
    self.acelerar(5000)
  }
  
  method estaTranquila() = (self.combustible() >= 4000) && (self.velocidad() < 1200)
  
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  
  method escapar()
  
  method avisar()
  
  method estaDeRelajo() {
    self.estaTranquila() && self.tienePocaActividad()
  }
  
  method tienePocaActividad()
}

class NaveBaliza inherits Nave {
  var color
  var cambiosDeColor = 0
  
  method colorDeBaliza() = color
  
  method cambiarColorDeBaliza(colorNuevo) {
    color = colorNuevo
    cambiosDeColor += 1
  }
  
  override method prepararViaje() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  
  override method estaTranquila() = super() && (self.colorDeBaliza() != "rojo")
  
  override method escapar() {
    self.irHaciaElSol()
  }
  
  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }
  
  override method tienePocaActividad() = cambiosDeColor == 0
}

class NavePasajero inherits Nave {
  const pasajeros
  var comida
  var bebida
  var racionesServidas = 0
  
  method pasajeros() = pasajeros
  
  method cargarComida(valor) {
    comida += valor
  }
  
  method cargarBebida(valor) {
    bebida += valor
  }
  
  method descargarComida(valor) {
    comida = (comida - valor).max(0)
    racionesServidas += valor
  }
  
  method descargarBebida(valor) {
    bebida = (bebida - valor).max(0)
  }
  
  override method prepararViaje() {
    self.cargarComida(pasajeros * 4)
    self.cargarBebida(pasajeros * 6)
    self.acercarseUnPocoAlSol()
  }
  
  override method escapar() {
    self.acelerar(velocidad)
  }
  
  override method avisar() {
    self.descargarComida(pasajeros)
    self.descargarBebida(pasajeros * 2)
  }
  
  override method tienePocaActividad() = racionesServidas < 50
}

class NaveCombate inherits Nave {
  var invisible
  var misilesDesplegados
  const mensajes = []
  
  method ponerseVisible() {
    invisible = false
  }
  
  method ponerseInvisible() {
    invisible = true
  }
  
  method estaInvisible() = invisible
  
  method desplegarMisiles() {
    misilesDesplegados = true
  }
  
  method replegarMisiles() {
    misilesDesplegados = false
  }
  
  method misilesDesplegados() = misilesDesplegados
  
  method emitirMensaje(mensaje) = mensajes.add(mensaje)
  
  method mensajesEmitidos() = mensajes
  
  method primerMensajeEmitido() = mensajes.first()
  
  method ultimoMensajeEmitido() = mensajes.last()
  
  method esEscueta() = mensajes.any({ m => m.length() > 30 })
  
  method emitioMensaje(mensaje) = mensajes.contains(mensaje)
  
  override method prepararViaje() {
    super()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(1500)
    self.emitirMensaje("Saliendo en misión")
  }
  
  override method estaTranquila() = super() && (!self.misilesDesplegados())
  
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  
  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveHospital inherits NavePasajero {
  var quirofanosPreparados
  
  method prepararQuirofano() {
    quirofanosPreparados = true
  }
  
  method quirofanoUsado() {
    quirofanosPreparados = false
  }
  
  method quirofanosPreparados() = quirofanosPreparados
  
  override method estaTranquila() = super() && (!self.quirofanosPreparados())
  
  override method recibirAmenaza() {
    super()
    self.prepararQuirofano()
  }
}

class NaveDeCombateSigilosa inherits NaveCombate {
  override method estaTranquila() = super() && (!self.estaInvisible())
  
  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}