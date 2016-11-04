package ceylon.interop.spring;

import ceylon.language.Integer;
import ceylon.language.String;
import com.redhat.ceylon.compiler.java.metadata.Ignore;
import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of {@link CeylonRepository}.
 *
 * @param <T> the entity type
 * @param <ID> the identifier type
 */
@Transactional(readOnly = true)
@TypeParameters({@TypeParameter(value = "T"), @TypeParameter(value="ID")})
@SuppressWarnings("unchecked")
public class CeylonRepositoryImpl<T,ID extends Serializable>
        extends SimpleJpaRepository<T,ID>
        implements CeylonRepository<T,ID> {

    public CeylonRepositoryImpl(JpaEntityInformation entityInformation, EntityManager entityManager) {
        super(entityInformation, entityManager);
    }

    @Override @Ignore
    public void delete(ID id) {
        super.delete(toJavaId(id));
    }

    @Override @Ignore
    public boolean exists(ID id) {
        return super.exists(toJavaId(id));
    }

    @Override @Ignore
    public T getOne(ID id) {
        return super.getOne(toJavaId(id));
    }

    @Override @Ignore
    public T findOne(ID id) {
        return super.findOne(toJavaId(id));
    }

    @Override @Ignore
    public List<T> findAll(Iterable<ID> ids) {
        List<ID> javaIds = new ArrayList<ID>();
        for (ID id: ids) {
            javaIds.add(toJavaId(id));
        }
        return super.findAll(javaIds);
    }

    private ID toJavaId(ID id) {
        Object javaId;
        if (id instanceof Integer) {
            javaId = ((Integer) id).longValue();
        }
        else if (id instanceof String) {
            javaId = id.toString();
        }
        else {
            javaId = id;
        }
        return (ID) javaId;
    }
}
