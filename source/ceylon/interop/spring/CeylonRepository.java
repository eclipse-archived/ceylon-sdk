package ceylon.interop.spring;

import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

import java.io.Serializable;

@NoRepositoryBean
@TypeParameters({@TypeParameter(value = "T"), @TypeParameter(value="ID")})
public interface CeylonRepository<T, ID extends Serializable>
        extends CrudRepository<T,ID> {}
