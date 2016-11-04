package ceylon.interop.spring;

import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

import java.io.Serializable;

/**
 * A {@link CrudRepository) which supports use of Ceylon
 * {@link ceylon.language.Integer} or
 * {@link ceylon.language.String} as an identifier type,
 * in place of Java's {@link java.lang.Long} or
 * {@link java.lang.String}.
 *
 * @param <T> the entity type
 * @param <ID> the identifier type
 */
@NoRepositoryBean
@TypeParameters({@TypeParameter(value = "T"), @TypeParameter(value="ID")})
public interface CeylonRepository<T, ID extends Serializable>
        extends CrudRepository<T,ID> {}
