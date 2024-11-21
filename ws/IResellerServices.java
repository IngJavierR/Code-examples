public interface IresellerServices {
    ValidaEquipoResponse validaDatosPrepago(ActivacionPrepago activacion, long idTransaccion, Long idSolicitud) throws Exception;
}