package mx.att.com.reseller.ws;

import mx.att.com.reseller.config.Factory;
import mx.att.com.reseller.logica.IResellerServicesLogica;
import mx.att.com.reseller.util.Utilerias;
import mx.att.com.reseller.vo.*;
import org.owasp.esapi.ESAPI;

import java.util.Map;

public class ResellerServices {

	/* Factory de Spring */

	private transient long idTransaccion = 0L;
	private final org.owasp.esapi.Logger LOG = ESAPI.getLogger(ResellerServices.class);
	private void log(String mensaje) {  LOG.info(org.owasp.esapi.Logger.EVENT_SUCCESS,idTransaccion + " >> " + mensaje); }
	private IResellerServicesLogica iresellerServices;
	public String ip = "";
	public Long idSolicitud = (long) 0;
	
	public RespuestaActivacionPrepago activacionPrepago(ActivacionPrepago activacion) throws Exception {
		// Obtener el ICCID de la activación y eliminar el último carácter
		String sim = activacion.getIccid();
		sim = sim.substring(0, sim.length()-1);
		// Convertir el ICCID a un ID de transacción
		long idTransaccion = Long.parseLong(sim);
		RespuestaActivacionPrepago respuestaActivacionPrepago = null;
		
		// Log de inicio del proceso de activación
		log("..::: Inicia activacionPrepago Elektra :::..");
		try {
			// Obtener los tokens necesarios para la activación
			Map<?, ?> datos = Utilerias.getTokens(activacion.getEsn());
			String ip = (String) datos.get("ip");
			long idSolicitud = Long.parseLong((String) datos.get("idReqSol"));
			activacion.setEsn((String) datos.get("esnDn"));
		} catch (Exception e) {
			// Log de error en caso de fallo al actualizar el registro de persistencia
			log("IDRASTRO: " + idTransaccion + " BD-ACT-00001 : Error al actualizar el registro de persistencia: " + e.getMessage());
		}
		
		try {
			// Obtener la instancia del servicio de reseller
			IResellerServices iresellerServices = Factory.getFactoryLogic();
			// Llamar al método de activación de prepago
			respuestaActivacionPrepago = iresellerServices.activacionPrepago(activacion, idTransaccion, idSolicitud);
		} catch (Exception e) {
			// Log de error en caso de fallo en la activación de prepago
			log("Error activacionPrepago Elektra " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{" + idSolicitud + "} met:{activacionPrepago}", e.getCause());
		}
		// Log de finalización del proceso de activación
		log("..::: Termina activacionPrepago Elektra :::..");
		// Modificar el DN de la respuesta de activación
		respuestaActivacionPrepago.setDn(respuestaActivacionPrepago.getDn() + "?" + idSolicitud);
		return respuestaActivacionPrepago;
	}

	public RespuestaActivacionBO activacionPrepagoCoppel(ActivacionBO activacion) throws Exception{
		// Obtener el ICCID de la activación
		String sim = activacion.getIccid();
		// Remover el último carácter del ICCID
		sim = sim.substring(0, sim.length()-1);
		// Convertir el ICCID a un ID de transacción
		idTransaccion = Long.parseLong(sim);
		RespuestaActivacionBO respuestaActivacionBO = null;
		// Log de inicio del proceso de activación
		log("..::: Inicia activacionPrepago Coppel :::..");
		try {
			// Obtener tokens a partir del IMEI
			Map<?, ?> datos = Utilerias.getTokens(activacion.getImei());
			// Asignar valores obtenidos a variables locales
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			activacion.setImei((String)datos.get("esnDn"));
		
		}catch(Exception e) {
			// Log de error en caso de fallo al actualizar el registro de persistencia
			log("IDRASTRO: "+idTransaccion+" "+" Error al actualizar el registro de persistencia: "
					+ e.getMessage());
		}
		
		try {
			// Obtener instancia de servicios de reseller
			iresellerServices = Factory.getFactoryLogic();
			// Llamar al servicio de activación prepago Coppel
			respuestaActivacionBO = iresellerServices.activacionPrepagoCoppel(activacion, idTransaccion,idSolicitud);
		
		} catch (Exception e) {
			// Log de error en caso de fallo en la activación prepago Coppel
			log("Error activacionPrepago Coppel " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{activacionPrepagoCoppel}", e.getCause());
		}
		// Log de finalización del proceso de activación
		log("..::: Termina activacionPrepago Coppel :::..");
		
		// Modificar el número en la respuesta de activación
		respuestaActivacionBO.setNumero(respuestaActivacionBO.getNumero()+"?"+idSolicitud.toString());

		return respuestaActivacionBO;
		
	}
	
	public ValidaEquipoResponse validaDatosPrepago(ActivacionPrepago activacion)throws Exception {
		String sim = activacion.getIccid();
		sim = sim.substring(0, sim.length()-1);
		idTransaccion = Long.parseLong(sim);
		
		ValidaEquipoResponse validaEquipoResponse = null;
		log("..::: Inicia ValidaDatosPrepago :::..");
		try {
			Map<?, ?> datos = Utilerias.getTokens(activacion.getEsn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			activacion.setEsn((String)datos.get("esnDn"));
		
		}catch(Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: "
					+ e.getMessage());
		}
		
		try {
			iresellerServices = Factory.getFactoryLogic();
			validaEquipoResponse = iresellerServices.validaDatosPrepago(activacion, idTransaccion,idSolicitud);	
		} catch (Exception e) {
			log("Error ValidaDatosPrepago " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{validaDatosPrepago}", e.getCause());
		}
		log("..::: Termina ValidaDatosPrepago :::..");
		validaEquipoResponse.setMsgBSCS(validaEquipoResponse.getMsgBSCS()+"?"+idSolicitud.toString());
		return validaEquipoResponse;
	}
	
	
	public RespuestaActivacion activacion(Activacion activacion) throws Exception {
		String sim = activacion.getIccid();
		sim = sim.substring(0, sim.length()-1);
		idTransaccion = Long.parseLong(sim);
		
		RespuestaActivacion respuestaActivacion = null;
		log("..::: Inicia activacion :::..");
		
		try {
			Map<?, ?> datos = Utilerias.getTokens(activacion.getEsn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			activacion.setEsn((String)datos.get("esnDn"));
		} catch (Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: "
					+ e.getMessage());
		}
		try {
			iresellerServices = Factory.getFactoryLogic();
			respuestaActivacion = iresellerServices.activacion(activacion, idTransaccion,idSolicitud);
			log("Respuesta activacion " +respuestaActivacion.toString());
		} catch (Exception e) {
			log("Error activacion Elektra" + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{activacion}", e.getCause());
		}
		log("..::: Termina activacion :::..");
		respuestaActivacion.setDn(respuestaActivacion.getDn()+"?"+idSolicitud.toString());
	return respuestaActivacion;
	} 
	
	public RespuestaActivacion activarCombo(Activacion activacion) throws Exception{
		String sim = activacion.getIccid();
		sim = sim.substring(0, sim.length()-1);
		idTransaccion = Long.parseLong(sim);
		
		RespuestaActivacion respuestaActivacion = null;
		log("..::: Inicia activarCombo :::..");
		try {
			Map<?, ?> datos = Utilerias.getTokens(activacion.getEsn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			activacion.setEsn((String)datos.get("esnDn"));
		}catch(Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: " + e.getMessage());
		}
		
		try {
			iresellerServices = Factory.getFactoryLogic();
			respuestaActivacion = new RespuestaActivacion();
			respuestaActivacion = iresellerServices.activarCombo(activacion, idTransaccion,idSolicitud);
			log("Respuesta activarCombo " +respuestaActivacion.toString());
		} catch (Exception e) {
			log("Error activarCombo " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{activarCombo}", e.getCause());
		}
		log("..::: Termina activarCombo :::..");
		respuestaActivacion.setDn(respuestaActivacion.getDn()+"?"+idSolicitud.toString());
	return respuestaActivacion;
	} 
	
	
	public RespuestaActivacionCombo adicionaLineaCombo(LineaComboVo lineaComboVo) throws Exception{
		String sim = lineaComboVo.getIccid();
		sim = sim.substring(0, sim.length()-1);
		idTransaccion = Long.parseLong(sim);
		
		RespuestaActivacionCombo respuestaActivacion = null;
		log("..::: Inicia adicionaLineaCombo :::..");
		
		try {
			Map<?, ?> datos = Utilerias.getTokens(lineaComboVo.getEsn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			lineaComboVo.setEsn((String)datos.get("esnDn"));
		}catch(Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: "
					+ e.getMessage());
		}
	
		try {
			iresellerServices = Factory.getFactoryLogic();
			respuestaActivacion = iresellerServices.adicionaLineaCombo(lineaComboVo, idTransaccion,idSolicitud);
			log("Respuesta adicionaLineaCombo " +respuestaActivacion.toString());
		} catch (Exception e) {
			log("Error activarCombo " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{adicionaLineaCombo}", e.getCause());
		}
		log("..::: Termina adicionaLineaCombo :::..");
		respuestaActivacion.setDn(respuestaActivacion.getDn()+"?"+idSolicitud.toString());
	return respuestaActivacion;
	} 
	
	public RespuestaRenovacion newRenovacion(RenovacionVo renovacion) throws Exception {
		String sim = renovacion.getIccid();
		sim = sim.substring(0, sim.length()-1);
		idTransaccion = Long.parseLong(sim);
		
		RespuestaRenovacion respuestaRenovacion = null;
		log("..::: Inicia newRenovacion :::..");
		
		try {
			Map<?, ?> datos = Utilerias.getTokens(renovacion.getEsn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			renovacion.setEsn((String)datos.get("esnDn"));
		}catch(Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: " + e.getMessage());
		}
		
		try {
			iresellerServices = Factory.getFactoryLogic();
			respuestaRenovacion = new RespuestaRenovacion();
			respuestaRenovacion = iresellerServices.newRenovacion(renovacion, idTransaccion, idSolicitud);
			log("Respuesta newRenovacion"+ respuestaRenovacion.toString());
		} catch (Exception e) {
			log("Error newRenovacion " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{newRenovacion}", e.getCause());
		}
		
		log("..::: Termina newRenovacion :::..");
		respuestaRenovacion.setDn(respuestaRenovacion.getDn()+"?"+idSolicitud.toString());
		return respuestaRenovacion;
	}
	
	public RespuestaKYH newRenovacionKYH(RenovacionKYH renovacion)throws Exception {
		String dn = renovacion.getDn();
		idTransaccion = Long.parseLong(dn);
		
		RespuestaKYH respuestaKYH = null;
		log("..::: Inicia newRenovacionKYH :::..");
		
		try {
			Map<?, ?> datos = Utilerias.getTokens(renovacion.getDn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			renovacion.setDn((String)datos.get("esnDn"));
		} catch(Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: " + e.getMessage());
		}
		
		try {
			iresellerServices = Factory.getFactoryLogic();
			respuestaKYH = new RespuestaKYH();
			respuestaKYH = iresellerServices.newRenovacionKYH(renovacion, idTransaccion, idSolicitud);
			log("Respuesta newRenovacionKYH"+ respuestaKYH.toString());
		} catch (Exception e) {
			log("Error newRenovacionKYH " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{newRenovacionKYH}", e.getCause());
		}
		log("..::: Termina newRenovacionKYH :::..");
		respuestaKYH.setDn(respuestaKYH.getDn()+"?"+idSolicitud.toString());
		return respuestaKYH;
	}
	
	public ValidaEquipoResponse validaDatosActivacion(Activacion activacion) throws Exception {
		String sim = activacion.getIccid();
		sim = sim.substring(0, sim.length()-1);
		idTransaccion = Long.parseLong(sim);
		
		ValidaEquipoResponse validaEquipoResponse = null;
		log("..::: Inicia validaDatosActivacion :::..");
		
		try {
			Map<?, ?> datos = Utilerias.getTokens(activacion.getEsn());
			ip = (String) datos.get("ip");
			idSolicitud = new Long((String) datos.get("idReqSol"));
			activacion.setEsn((String)datos.get("esnDn"));
		}catch(Exception e) {
			log("IDRASTRO: "+idTransaccion+" "+"BD-ACT-00001 : Error al actualizar el registro de persistencia: " + e.getMessage());
		}
		
		try {
			iresellerServices = Factory.getFactoryLogic();
			validaEquipoResponse = iresellerServices.validaDatosActivacion(activacion,idTransaccion, idSolicitud);
		} catch (Exception e) {
			log("Error validaDatosActivacion " + e.getMessage());
			throw new Exception(e.getMessage() + " iRS:{"+ idSolicitud.toString().trim() + "}"+ "met:{validaDatosActivacion}", e.getCause());
		}
		log("..::: Termina validaDatosActivacion :::..");
		validaEquipoResponse.setMsgBSCS(validaEquipoResponse.getMsgBSCS()+"?"+idSolicitud.toString());
		return validaEquipoResponse;
	}
		
}